//
//  ContactsScreen.swift
//  loginSwiftUIDemo
//
//  Created by mac on 02.08.2023.
//

import SwiftUI

struct ContactsScreen: View {
    @EnvironmentObject var contactsVM: ContactsVM
    var body: some View {
        VStack {
            Text("Contacts").padding(5)
            
            if contactsVM.status == .loaded && contactsVM.items.isEmpty {
                Text("No people in the app. Invite your friends")
                    .multilineTextAlignment(.center)
                    .padding(10)
            } else if contactsVM.status == .loaded && !contactsVM.items.isEmpty {
                TextField("Type term", text: $contactsVM.search)
                    .padding(5)
                    .border(.indigo).buttonBorderShape(.capsule)
                    .background (Color.white)
                    .padding(5)
                    
                List(contactsVM.items.filter({ c in
                    contactsVM.search.isEmpty || c.name.contains(contactsVM.search)
                })) { item in
                    Text(item.name)
                }
            } else if contactsVM.status == .failed {
                Text("Something went wrong")
                Button("Reload") {
                    contactsVM.load()
                }
            } else {
                ProgressView()
            }
        }.task {
            contactsVM.load()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.2, green: 0.0, blue: 0.2,  opacity: 0.4 ))
    }
}

class ContactsVM: ObservableObject {
    @Published private(set) var status: EntityStastus = .initial
    @Published private(set) var items: [Contact] = []
    @Published fileprivate(set) var search: String = ""
    
    func load() {
        status = .loaded
        items = [Contact(id: "0", name: "Bob"),
                 Contact(id: "1", name: "Sarah"),
                 Contact(id: "2", name: "Tom")]
    }
}

struct ContactsScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContactsScreen()
            .environmentObject(ContactsVM())
    }
}
