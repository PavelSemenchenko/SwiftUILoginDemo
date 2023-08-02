//
//  TabBar.swift
//  loginSwiftUIDemo
//
//  Created by mac on 02.08.2023.
//

import SwiftUI

enum TabBarId: Int, Hashable {
    case home = 0
    case todo = 1
    case contacts = 2
}

struct TabBar: View {
    
    @State var currentTab = TabBarId.home
    
    var body: some View {
        VStack {
            Button("Change") {
                currentTab = TabBarId.todo
            }
            TabView(selection: $currentTab) {
                Text("Tab 1").tabItem {
                    Text("Home")
                }.tag(TabBarId.home)
                /*TodosScreen().tabItem {
                    Text("Todo")
                        .environmentObject(TodoVM())
                        .environmentObject(SignInVM())
                }.tag(TabBarId.todo)
                 */
                ContactsScreen().tabItem {
                    Text("Contacts")
                }.tag(TabBarId.contacts).environmentObject(ContactsVM())
            }
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
