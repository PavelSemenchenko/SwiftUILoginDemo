//
//  SignInVM.swift
//  loginSwiftUIDemo
//
//  Created by mac on 08.06.2023.
//

import Foundation
import FirebaseAuth
import FirebaseAuthCombineSwift

class SignInVM: ObservableObject {
    @Published var email : String = "test@test.com"
    @Published var password: String = "qwerty"
    @Published var loginActive: Bool = false
    
    
    var isEmailCorrect: Bool {
        email.contains("@")
    }
    
    var isPaswordCorrect: Bool {
        get {
            return password.count >= 6
        }
    }
    
    var canLogin: Bool {
        return isEmailCorrect && isPaswordCorrect
    }
    
    @MainActor func login() async {
        loginActive = true
        do {
            let result = try? await Auth.auth().signIn(withEmail: email, password: password)
//            open home
        } catch {
            
        }
        loginActive = false
    }
}
