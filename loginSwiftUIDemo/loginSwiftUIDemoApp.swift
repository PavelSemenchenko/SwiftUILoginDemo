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
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                TodosScreen()
               // SplashView()
            }
            .environmentObject(SignInVM())
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
