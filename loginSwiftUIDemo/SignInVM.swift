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
    @Published var busy: Bool = false
    
    
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
    
    class var isAuthenticated: Bool {
        Auth.auth().currentUser != nil
    }
    
    @MainActor func signIn() async {
        busy = true
        do {
            let result = try? await Auth.auth().signIn(withEmail: email, password: password)
//            open home
        } catch {
            
        }
        busy = false
    }
    @MainActor func signUp() async {
        busy = true
        do {
            let result = try? await Auth.auth().createUser(withEmail: email, password: password)
//            open home
        } catch {
            
        }
        busy = false
    }
}
