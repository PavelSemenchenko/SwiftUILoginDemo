//
//  loginSwiftUIDemoApp.swift
//  loginSwiftUIDemo
//
//  Created by mac on 05.06.2023.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct loginSwiftUIDemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @ObservedObject var navigationVM = NavigationRouter()
   // @State var currentRoute = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationVM.currentRoute) {
                SplashView()
                    .navigationDestination(for: NavigationRoute.self) { route in
                        switch route {
                            
                        case .splash:
                            SplashView()
                        case .signIn:
                            SignInScreen()
                                .environmentObject(SignInVM())
                        case .signUp:
                            SignUpScreen()
                                .environmentObject(SignInVM())
                        case .todos:
                            TodosScreen()
                                .environmentObject(SignInVM())
                                .environmentObject(TodoVM())
                        case .createTodo:
                            CreateTodoScreen()
                        case .editTodo(let todo):
                            CreateTodoScreen(todo: todo)
                        case .contacts:
                            ContactsScreen()
                                .environmentObject(ContactsVM())
                        case .tabBar: TabBar()
                                .environmentObject(SignInVM())
                                .environmentObject(TodoVM())
                        case .followers: FollowersScreen()
                                .environmentObject(FollowersVM())
                        //case .followings:
                                //.environmentObject(FollowingsVM())
                        }
                    }
            }.environmentObject(navigationVM)
                .environment(\.colorScheme, .light)
        }
    }
}
