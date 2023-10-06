//
//  TabBar.swift
//  loginSwiftUIDemo
//
//  Created by mac on 02.08.2023.
//

import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift

enum TabBarId: Int, Hashable {
    case home = 0
    case todo = 1
    case contacts = 2
    case followers = 3
    case followings = 4
    case messages = 5
}

struct TabBar: View {
    
    @State var todosCount = 0
    @EnvironmentObject private var todosVM: TodoVM
    @State var todos: [Todo]?
    @EnvironmentObject private var loginVM: SignInVM
    @EnvironmentObject private var navigationVM: NavigationRouter
    
    @ObservedObject var homeVM = HomeVM()
    @State var unreadCount: Int = 0
    
    @State var currentTab = TabBarId.messages
    
    var body: some View {
        //HStack {
            TabView(selection: $currentTab) {
                
                MessagesScreen().tabItem {
                    VStack {
                        Text("Messages")
                        Image(systemName: "message")
                    }
                }.tag(TabBarId.messages)
                    .badge(unreadCount)
                
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
                    .onReceive(todosVM.todos) { todos in
                        todosCount = todos.count
                    }
                
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
                
            }.onReceive(homeVM.unreadCount) { amount in
            unreadCount = amount}
            .navigationBarBackButtonHidden(true)
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

class HomeVM: ObservableObject {
    lazy var unreadCount: AnyPublisher<Int, Never> = {
        Firestore.firestore().collection("messages")
            .whereField("read", isEqualTo: false)
            .whereField("recipient", isEqualTo: Auth.auth().currentUser!.uid)
            .snapshotPublisher()
            .map { $0.documents.count }
            .replaceError(with: 0)
            .eraseToAnyPublisher()
    }()
}
