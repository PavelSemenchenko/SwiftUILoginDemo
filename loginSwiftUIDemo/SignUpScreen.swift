//
//  SignUP.swift
//  loginSwiftUIDemo
//
//  Created by mac on 12.06.2023.
//

import Foundation
import SwiftUI

struct SignUpScreen: View {
    
    @ObservedObject private var loginVM = SignInVM()
    
    private var signInButtonColor: Color {
        var color: Color = !loginVM.canLogin ? .red : .blue
        if loginVM.loginActive {
            color = .orange
        }
        return color
    }
    
    var body: some View {
        VStack {
            Image(systemName: "figure.wave")
                .font(.largeTitle)
                .imageScale(.large)
            EditField(valid: loginVM.isEmailCorrect, placeholder: "Email", text: $loginVM.email)
            EditField(valid: loginVM.isPaswordCorrect, placeholder: "Password", text: $loginVM.password)
            MainButton(text: "Sign Up", enabled: loginVM.canLogin, busy: loginVM.loginActive)
        }.background(Color.gray)
            .padding()
    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen()
    }
}
