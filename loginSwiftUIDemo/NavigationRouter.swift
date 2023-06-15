//
//  NavigationRouter.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 15.06.2023.
//

import Foundation
import SwiftUI

class NavigationRouter {
    var signInRoute: () -> some View {
        func route() -> SignInScreen {
            SignInScreen()
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
