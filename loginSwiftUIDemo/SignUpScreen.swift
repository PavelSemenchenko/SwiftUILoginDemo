//
//  SignUP.swift
//  loginSwiftUIDemo
//
//  Created by mac on 12.06.2023.
//

import Foundation
import SwiftUI

struct SignUpScreen: View {
    @Binding var currentRoute: NavigationRoute
    @EnvironmentObject private var loginVM: SignInVM
    @Environment(\.navigationRouter) var navigationRouter: NavigationRouter
       
    var body: some View {
        VStack {
            Image(systemName: "figure.wave.circle.fill")
                .font(.largeTitle)
                .imageScale(.large)
                .padding(20)
            EditField(valid: loginVM.isEmailCorrect, placeholder: "Email", text: $loginVM.email)
            EditField(valid: loginVM.isPaswordCorrect, placeholder: "Password", text: $loginVM.password)
            HStack {
                MainButton(text: "Sign Up", enabled: loginVM.canLogin, busy: loginVM.busy) {
                    Task {
                        await loginVM.signUp()
                    }
                }.padding()
                NavigationLink("Enter account", destination: navigationRouter.signInRoute)
                    .foregroundColor(.white).padding(30)
            }
        }.padding(EdgeInsets(top: 50, leading: 32, bottom: 50 , trailing: 32))
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(LinearGradient(gradient: Gradient(colors: [.orange,.yellow, .red]), startPoint:.topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all))
            .edgesIgnoringSafeArea(.all)
    }
}
/*
struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen().environmentObject(SignInVM())
    }
}*/
