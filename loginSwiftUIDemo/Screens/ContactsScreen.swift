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
            Text("Contacts").padding(5)
            
            if contactsVM.status == .loaded && contactsVM.items.isEmpty {
                Text("No people in the app. Invite your friends")
                    .multilineTextAlignment(.center)
                    .padding(10)
            } else if contactsVM.status == .loaded && !contactsVM.items.isEmpty {
                ZStack(alignment: .trailing) {
                    TextField("Type term", text: $contactsVM.search)
                        .onChange(of: contactsVM.search, perform: { newValue in
                            Task {
                                await contactsVM.load()
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
                List(contactsVM.items.filter({ c in
                    contactsVM.search.isEmpty || c.name.contains(contactsVM.search)
                })) { item in
                    Text(item.name)
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
        }
        .onTapGesture {
            keyboardResposder.hideKeyboard()
        }
        .task {
            await contactsVM.load()
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
    
    @MainActor func load() async {
        status = search.isEmpty ? .loading : status
        var ref = Firestore.firestore().collection("people").order(by: "name")
        if !search.isEmpty {
            ref = ref.start(at: [search.lowercased()])
                .end(at: ["\(search.lowercased())"])
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
}

struct ContactsScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContactsScreen()
            .environmentObject(ContactsVM())
    }
}
