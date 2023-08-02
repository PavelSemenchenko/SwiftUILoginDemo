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
            TabView(selection: $currentTab) {
                
                Text("Tab 1").tabItem {
                HStack {
                    Text("Home")
                    Image(systemName: "house")
                }
                    }.tag(TabBarId.home)
#if DEBUG
                TodosScreen().tabItem {
                    Text("Todo")
                    Image(systemName: "list.clipboard")
                }.tag(TabBarId.todo)
                    .environmentObject(TodoVM())
                    .environmentObject(SignInVM())
                 
#endif
                ContactsScreen().tabItem {
                    VStack {
                        Text("Contacts")
                        Image(systemName: "person.3.sequence")
                    }
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
