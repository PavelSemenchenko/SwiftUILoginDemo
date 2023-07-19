//
//  NavigationRouter.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 15.06.2023.
//

import Foundation
import SwiftUI

enum NavigationRoute: Hashable {
    case signIn
    case signUp
    case todos
    case createTodo
    case editTodo(todo: Todo )
    case splash
    
}

class NavigationVM: ObservableObject {
    @Published var currentRoute: NavigationPath = NavigationPath()
    
    func pushScreen(route: NavigationRoute) {
        currentRoute.append(route)
    }
    func pushHome() {
        currentRoute.removeLast(currentRoute.count)
        pushScreen(route: .todos)
    }
    func popScreen() {
        currentRoute.removeLast()
    }
    func popUntilRootScreen() {
        currentRoute.removeLast(currentRoute.count)
        pushScreen(route: .splash)
    }
}

class NavigationRouter {
    var signInRoute: () -> some View {
        func route() -> SignUpScreen {
            SignUpScreen()
        }
        return route
    }
    var signUpRoute: () -> some View {
        func route() -> some View {
            SignUpScreen().environmentObject(SignInVM())
        }
        return route
    }
}
