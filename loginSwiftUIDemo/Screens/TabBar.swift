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
    case followers = 3
    case followings = 4
}

struct TabBar: View {
    
    @State var todosCount = 0
    @EnvironmentObject private var todosVM: TodoVM
    @State var todos: [Todo]?
    @EnvironmentObject private var loginVM: SignInVM
    @EnvironmentObject private var navigationVM: NavigationRouter
    
    @State var currentTab = TabBarId.contacts
    
    var body: some View {
        //HStack {
            TabView(selection: $currentTab) {
                
                TemplateScreen(tab: $currentTab).tabItem {
                    VStack {
                        Text("Home")
                        Image(systemName: "house")
                        
                    }
                }.tag(TabBarId.home)
                
                
                TodosScreen().tabItem {
                    VStack {
                        Text("Todos ")
                        Image(systemName: "list.clipboard")
                    }
                }.badge(todosCount)
                    .tag(TabBarId.todo)
                    //.environmentObject(SignInVM())
                    .onReceive(todosVM.todos) { todos in
                        todosCount = todos.count
                    }
                    //.toolbarBackground(Color.yellow, for: .tabBar)
                
                
                ContactsScreen().tabItem {
                    VStack {
                        Text("Contacts")
                        Image(systemName: "person.3.sequence")
                    }
                }.tag(TabBarId.contacts)
                    .environmentObject(ContactsVM())
                
                FollowersScreen().tabItem {
                    VStack{
                        Text("Followers")
                        Image(systemName: "person.line.dotted.person.fill")
                    }
                }.tag(TabBarId.followers)
                    .environmentObject(FollowersVM())
                
                FollowingScreen().tabItem {
                    VStack{
                        Text("Followings")
                        Image(systemName: "person.crop.circle.badge.checkmark")
                    }
                }.tag(TabBarId.followings)
                
            }.navigationBarBackButtonHidden(true)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
            .environmentObject(TodoVM())
            .environmentObject(NavigationRouter())
            .environmentObject(SignInVM())
    }
}
