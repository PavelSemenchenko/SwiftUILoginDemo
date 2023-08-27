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
}

struct TabBar: View {
    
    @State var todosCount = 0
    @EnvironmentObject private var todosVM: TodoVM
    @State var todos: [Todo]?
    @EnvironmentObject private var loginVM: SignInVM
    @EnvironmentObject private var navigationVM: NavigationRouter
    
    @State var currentTab = TabBarId.home
    
    var body: some View {
        VStack {
            TabView(selection: $currentTab) {
                
                Button("logout"){
                    navigationVM.pushScreen(route: .signIn)
                }.tabItem {
                ZStack {
                    Text("Home")
                    Image(systemName: "house")
                    
                }
                    }.tag(TabBarId.home)
                
                
                TodosScreen().tabItem {
                    ZStack {
                       // Text("Todos ")
                        Text("Todos \(todosCount)")
                            .onReceive(todosVM.todos) { todos in
                            todosCount = todos.count
                                print("------ Todos count \(todos.count)")
                                print(todos)
                                
                            }
                    }
                    Image(systemName: "list.clipboard")
                }.tag(TabBarId.todo)
                    .environmentObject(TodoVM())
                    .environmentObject(SignInVM())
                    .environmentObject(NavigationRouter())
                    .toolbarBackground(
                            Color.yellow,
                            for: .tabBar)
                
                
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
                }.tag(TabBarId.followers).environmentObject(FollowersVM())
                
            }
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
