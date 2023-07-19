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
    
    @ObservedObject var navigationVM = NavigationVM()
   // @State var currentRoute = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationVM.currentRoute) {
                ProgressView()
                    .navigationDestination(for: NavigationRoute.self) { route in
                        switch route {
                        
                        case .splash:
                            SplashView()
                                .environmentObject(SignInVM())
                            /*
                            ProgressView().onAppear {
                                SignInVM.isAuthenticated ? NavigationRoute.todos : NavigationRoute.signIn
                            }
                             */
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
                        }
                    }
            }.task {
                SignInVM.isAuthenticated ? navigationVM.pushHome() : navigationVM.popUntilRootScreen()
                // navigationVM.pushScreen(route: SignInVM.isAuthenticated ? .todos : .signIn)
            }.environmentObject(navigationVM)
        }
    }
}

struct DependenciesKey: EnvironmentKey {
    static var defaultValue: NavigationRouter = NavigationRouter()
    typealias Value = NavigationRouter
}

extension EnvironmentValues {
    var navigationRouter: NavigationRouter {
        get { self[DependenciesKey.self] }
        set { self[DependenciesKey.self] = newValue}
    }
}
