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
    case contacts
    case tabBar
    case followers
    
}

class NavigationRouter: ObservableObject {
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
    func popUntilSignInScreen() {
        currentRoute.removeLast(currentRoute.count)
        pushScreen(route: .signIn)
    }
    func pushContacts(route: NavigationRoute) {
        pushScreen(route: .contacts)
    }
    func pushTabBar(route: NavigationRoute) {
        pushScreen(route: .tabBar)
    }
}
