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
                    
                    // добавить очистку массива и запуск load
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
                                    await contactsVM.loadMore()
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
                    ForEach(1..<10) { i in
                        HStack(alignment: .center) {
                            Spacer()
                            Image(systemName: "person.circle").padding()
                            Text("Loading template ... \(i)")
                            Spacer()
                        }.border(Color(CGColor(red: 6, green: 0, blue: 9, alpha: 0.6)))
                    }
            }
        }.task {
            //await contactsVM.load()
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
    @MainActor func load() async {
        print("\(#function) \(items.count)")
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
    }
*/
    
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
        
        let contacts = snapshot.documents.map { doc in
            try! doc.data(as: Contact.self)
        }.compactMap { $0 }
        status = .loaded
        items = contacts
    }
    
    @MainActor func load(more: Bool = false) async  {
        if more && (allLoaded || status == .moreLoading) {
            return
        }
        print("\(#function) \(items.count)")
        status = more ? .moreLoading : .loading

        var ref = Firestore.firestore().collection("people").order(by: "name")
                .limit(to: 20)
        if let doc = latestDocument, more {
            ref.start(afterDocument: doc)
        }
        guard let snapshot = try? await ref.getDocuments() else {
            status = .failed
            return
        }
        
        allLoaded = snapshot.documents.last == nil
        latestDocument = snapshot.documents.last
        
        let contacts = snapshot.documents.map { doc in
                    try! doc.data(as: Contact.self)
                }.compactMap {$0}
        status = .loaded
        items.append(contentsOf: contacts)
    }
    
    @MainActor func loadMore() async {
        if status == .moreLoading {
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
        
        latestDocument = snapshot.documents.last
        
        let contacts = snapshot.documents.map { doc in
            try! doc.data(as: Contact.self)
        }.compactMap { $0 }
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
