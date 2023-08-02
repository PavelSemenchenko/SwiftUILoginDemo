//
//  TabBar.swift
//  loginSwiftUIDemo
//
//  Created by mac on 02.08.2023.
//

import SwiftUI

enum TabId: Int, Hashable {
    case home = 0
    case todo = 1
    case contacts = 2
}

struct TabBar: View {
    
    @State var currentTab = TabId.home
    
    var body: some View {
        VStack {
            Button("Change") {
                currentTab = TabId.todo
            }
            TabView(selection: $currentTab) {
                Text("Tab 1").tabItem {
                    Text("Home")
                }.tag(TabId.home)
                Text("Tab 2").tabItem {
                    Text("Todo")
                }.tag(TabId.todo)
                Text("Tab 3").tabItem {
                    Text("Contacts")
                }.tag(TabId.contacts)
            }
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
