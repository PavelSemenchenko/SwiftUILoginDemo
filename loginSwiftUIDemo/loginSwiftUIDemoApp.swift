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
    
    @State var currentRoute: NavigationRoute = .splash
    
    var body: some Scene {
        WindowGroup {
            
            switch currentRoute {
            case .splash:
                ProgressView().onAppear {
                    currentRoute = SignInVM.isAuthenticated ? .todos : .signIn
                }
            case .signIn:
                SignInScreen(currentRoute: $currentRoute)
                    .environmentObject(SignInVM())
            case .signUp:
                SignUpScreen()
                    .environmentObject(SignInVM())
            case .todos:
                TodosScreen(currentRoute: $currentRoute)
                    .environmentObject(SignInVM())
                    .environmentObject(TodoVM())
            case .createTodo:
                CreateTodoScreen()
                    .environmentObject(SignInVM())
            }
            /*
            NavigationView {
                if SignInVM.isAuthenticated {
                    TodoView()
                } else {
                    SignInScreen()
                }
            }
            .environmentObject(SignInVM())
             */
        }
    }
}
/*
struct TodoView: View {
    var body: some View {
        TabView {
            TodosScreen().tabItem {
                Image(systemName: "house")
            }
            SignInScreen().tabItem {
                Image(systemName: "person")
            }
            
        }
    }
}
*/
/*
class DemoDependecies: ObservedObject {
    let signInVM = signInVM(name: "in")
    let signUpVM = signInVM(name: "up")
}
 */


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
