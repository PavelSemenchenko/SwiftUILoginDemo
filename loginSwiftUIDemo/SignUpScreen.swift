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
            Image(systemName: "figure.wave.circle.fill")
                .font(.largeTitle)
                .imageScale(.large)
                .padding(20)
            EditField(valid: loginVM.isEmailCorrect, placeholder: "Email", text: $loginVM.email)
            EditField(valid: loginVM.isPaswordCorrect, placeholder: "Password", text: $loginVM.password)
            MainButton(text: "Sign Up", enabled: loginVM.canLogin, busy: loginVM.loginActive)
        }.padding(EdgeInsets(top: 50, leading: 32, bottom: 50 , trailing: 32))
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(LinearGradient(gradient: Gradient(colors: [.orange,.yellow, .red]), startPoint:.topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all))
            .edgesIgnoringSafeArea(.all)
    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen()
    }
}
