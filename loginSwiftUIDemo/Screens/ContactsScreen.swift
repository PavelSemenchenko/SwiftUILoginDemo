//
//  ContactsScreen.swift
//  loginSwiftUIDemo
//
//  Created by mac on 02.08.2023.
//

import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift


struct ContactsScreen: View {
    //@EnvironmentObject var contactsVM: ContactsVM
    @StateObject var contactsVM: ContactsVM = ContactsVM()
    @State private var keyboardHeight: CGFloat = 0
    @ObservedObject private var keyboardResposder = KeyboardResponder()
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        VStack {
            Text("Contacts").font(.headline).padding(5)
            if contactsVM.status == .searching && contactsVM.items.isEmpty {
                Text("No user found with name \(contactsVM.search)")
                    .multilineTextAlignment(.center)
                    .padding(10)
            }
            if contactsVM.status == .loaded && contactsVM.items.isEmpty {
                Text("No people in the app. Invite some one")
                    .multilineTextAlignment(.center)
                    .padding()
            } else if (contactsVM.status == .loaded || contactsVM.status == .searching || contactsVM.status == .moreLoading) && !contactsVM.items.isEmpty {
                ZStack(alignment: .trailing) {
                    TextField("Type term", text: $contactsVM.search)
                        .onChange(of: contactsVM.search, perform: { newValue in
                            Task {
                                await contactsVM.search()
                            }
                        })
                        .padding(5)
                        .cornerRadius(5)
                        .textFieldStyle(.roundedBorder)
                        .padding(5)
                    /*
                     Button (action: {
                     contactsVM.search = ""
                     }) {
                     Image(systemName: "xmark.circle.fill")
                     .foregroundColor(.gray)
                     }
                     .padding(.trailing, 15)
                     //.opacity(contactsVM.search.isEmpty ? 0 : 1)
                     */
                    if !contactsVM.search.isEmpty {
                        Button (action: {
                            contactsVM.search = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 15)
                    }
                    
                }
                List(contactsVM.items) { item in
                    Text(item.name).padding()
                        .onAppear {
                            if contactsVM.items.count
                                - (contactsVM.items.lastIndex(of: item) ?? 0) < 5 {
                                Task {
                                    await contactsVM.load(more: true)
                                }
                            }
                        }
                    
                }
            } else if contactsVM.status == .failed {
                Text("Something went wrong")
                Button("Reload") {
                    Task {
                        await contactsVM.load()
                    }
                }
            } else {
                ProgressView()
            }
        }.task {
            await contactsVM.load()
        }
        .onTapGesture {
            keyboardResposder.hideKeyboard()
        }
        
        .padding(.bottom, keyboardHeight)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onReceive(keyboardResposder.key1boardHeight, perform: { height in
            keyboardHeight = height - 100
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.keyboard)
        .background(Color(red: 0.2, green: 0.0, blue: 0.2,  opacity: 0.4 ))
    }
    
}



class ContactsVM: ObservableObject {
    @Published private(set) var status: EntityStastus = .initial
    @Published private(set) var items: [Contact] = []
    @Published fileprivate(set) var search: String = ""
    
    private var allLoaded = false
    private var latestDocument: DocumentSnapshot?
    /*
     init() {
     $search.sink { tern in
     Task {
     await self.load()
     }
     }
     }*/
    
    @MainActor func load() async {
        status = search.isEmpty ? .loading : status
        var ref = Firestore.firestore().collection("people").order(by: "name")
        if !search.isEmpty {
            ref = ref.start(at: [search.lowercased()])
                .end(at: ["\(search.lowercased())~"])
        }
        guard let snapshot = try? await ref.getDocuments() else {
            status = .failed
            return
        }
        let contacts = snapshot.documents.map { doc in
            try! doc.data(as: Contact.self)
        }.compactMap { $0 }
        status = .loaded
        items = contacts
        
        print(status)
        print(items)
        /*
         func load() {
         status = .loaded
         items = [Contact(id: "0", name: "Bob"),
         Contact(id: "1", name: "Sarah"),
         Contact(id: "2", name: "Tom"),
         Contact(id: "3", name: "Sam"),
         Contact(id: "4", name: "Robert"),
         Contact(id: "5", name: "Natan"),
         Contact(id: "6", name: "Poule"),
         Contact(id: "7", name: "Pouile"),
         Contact(id: "8", name: "Juseppe"),
         Contact(id: "9", name: "Cassidy"),
         Contact(id: "10", name: "Grand"),
         Contact(id: "11", name: "Sarah"),
         Contact(id: "12", name: "Sarah"),
         Contact(id: "13", name: "Tom")]
         */
    }
    
    @MainActor func search() async {
        status = .searching
        var ref = Firestore.firestore().collection("people").order(by: "name")
        if !search.isEmpty {
            ref = ref.start(at: [search.lowercased()]).end(at: ["\(search.lowercased())~"])
        }
        guard let snapshot = try? await ref.getDocuments() else {
            status = .failed
            return
        }
        allLoaded = snapshot.documents.last == nil
        latestDocument = snapshot.documents.last
        
        let contacts = snapshot.documents.map { doc in
            try! doc.data(as: Contact.self)
        }.compactMap { $0 }
        status = .loaded
        items.append(contentsOf: contacts)
    }
    
    @MainActor func loadMore() async {
        if allLoaded || status == .moreLoading {
            return
        }
        guard let doc = latestDocument else {
            return
        }
        print("Load \(items.count)")
        status = .moreLoading
        
        let ref = Firestore.firestore().collection("people").order(by: "name").limit(to: 15).start(afterDocument: doc)
        guard let snapshot = try? await ref.getDocuments() else {
            return
        }
        allLoaded = snapshot.documents.last == nil
        latestDocument = snapshot.documents.last
        
        let contacts = snapshot.documents.map { doc in
            try! doc.data(as: Contact.self)
        }.compactMap { $0 }
        status = .loaded
        items.append(contentsOf: contacts)
    }
    
    @MainActor func load(more: Bool = false) async  {
        print("\(#function) \(items.count)")
        status = more ? status : .loading
        
        var ref = Firestore.firestore().collection("people").order(by: "name")
            .limit(to: 20)
        if let doc = latestDocument {
            ref.start(afterDocument: doc)
        }
        guard let snapshot = try? await ref.getDocuments() else {
            status = .failed
            return
        }
        latestDocument = snapshot.documents.last
        let contacts = snapshot.documents.map { doc in
            try! doc.data(as: Contact.self)
        }.compactMap {$0}
        status = .loaded
        items.append(contentsOf: contacts)
    }
}

struct ContactsScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContactsScreen()
            .environmentObject(ContactsVM())
    }
}
