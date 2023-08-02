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
            Text("Contacts")
            
            if contactsVM.status == .loaded && contactsVM.items.isEmpty {
                Text("No people in the app. Invite your friends")
                    .multilineTextAlignment(.center)
                    .padding()
            } else if contactsVM.status == .loaded && !contactsVM.items.isEmpty {
                List(contactsVM.items) { item in
                    Text(item.name)
                }
            } else if contactsVM.status == .failed {
                Text("Something went wrong")
                Button("Reload") {
                    contactsVM.load()
                }
            }
        }
    }
}

class ContactsVM: ObservableObject {
    @Published private(set) var status: EntityStastus = .initial
    @Published private(set) var items: [Contact] = []
    
    func load() {
        status = .loaded
        items = [Contact(name: "Bob"), Contact(name: "Sarah"), Contact(name: "Tom")]
    }
}

struct ContactsScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContactsScreen()
            .environmentObject(ContactsVM())
    }
}
