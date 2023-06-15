//
//  ContentView.swift
//  loginSwiftUIDemo
//
//  Created by mac on 05.06.2023.
//

import SwiftUI

struct SignInScreen: View {
    
    @EnvironmentObject private var loginVM : SignInVM
    @Environment(\.navigationRouter) var navigationRouter : NavigationRouter
    // observ another page
    @State private var isShowingModal = false
    
    //    не работает смена цвета
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.red]
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "figure.wave")
                    .font(.largeTitle)
                    .imageScale(.large)
                    .padding(20)
                EditField(valid: loginVM.isEmailCorrect, placeholder: "Email", text: $loginVM.email)
                EditField(valid: loginVM.isPaswordCorrect, placeholder: "Password", text: $loginVM.password)
                
                MainButton(text: "Sign In", enabled: loginVM.canLogin, busy: loginVM.busy) {
                    Task {
                        await loginVM.signIn()
                    }
                }
                
                VStack {
                    HStack {
                        NavigationLink(destination: navigationRouter.signUpRoute) {
                            MainButton(text: "Create account", enabled: true, busy: false) {
                                
                            }
                        }
                        NavigationLink("Create account") {
                            SignUpScreen()
                        }
                        .foregroundColor(.white)
                    }
                    Button("Agreements") {
                        isShowingModal.toggle()
                    }.sheet(isPresented: $isShowingModal) {
                        AnotherView()
                    }.navigationBarTitle("Entering")
                        .foregroundColor(.red)
                    
                }
            }
            .padding(EdgeInsets(top: 50, leading: 32, bottom: 50 , trailing: 32))
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all))
            .edgesIgnoringSafeArea(.all)
        }
        
    }
}

// Agreements
struct AnotherView: View {
    var body: some View {
        ScrollView {
            Text("Правила использования приложения : Мы будем использовать все получаемые данные в коммерческих целях и использовать в публичном доступе. Если вы не согласны с открытой публикацией ваших данный фото-видео -текстового контента - виявите свое заявление перед посещением и использованием нашего сервиса.")
                .padding(EdgeInsets(top: 36, leading: 16, bottom: 36, trailing: 16))
                .frame(maxWidth: .infinity)
                .padding()
        }
    }
}
struct AnotherView2: View {
    var body: some View {
        Text("Windows 2 opened")
            .frame(height: UIScreen.main.bounds.height)
            .background(Color.red)
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreen().environmentObject(SignInVM())
    }
}
