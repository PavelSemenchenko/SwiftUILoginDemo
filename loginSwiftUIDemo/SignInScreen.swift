//
//  ContentView.swift
//  loginSwiftUIDemo
//
//  Created by mac on 05.06.2023.
//

import SwiftUI

struct SignInScreen: View {
    @EnvironmentObject private var navigarionVM: NavigationVM
    @EnvironmentObject private var loginVM : SignInVM
    @Environment(\.navigationRouter) var navigationRouter : NavigationRouter
    
    @State private var isShowingModal = false
    
    var body: some View {
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
                        // open TODOs
                        navigarionVM.pushHome()
                        //navigarionVM.pushScreen(route: .todos)
                    }
                }
                
                VStack {
                    HStack {
                        
                        MainButton(text: "Create account", enabled: true, busy: false) {
                            navigarionVM.pushScreen(route: .signUp)
                        }
                        NavigationLink("TabBar") {
//                            TabBar()
                        }
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

// Agreements
struct AnotherView: View {
    var body: some View {
        HStack {
            ScrollView {
                Button {
                    print("ok")
                } label: {
                    VStack {
                        Image(systemName: "key")
                            .font(.largeTitle)
                            .imageScale(.large)
                            .padding(20)
                        Text("get license")
                    }.background(Color.black)
                }
                Text("Правила использования приложения : Мы будем использовать все получаемые данные в коммерческих целях и использовать в публичном доступе. Если вы не согласны с открытой публикацией ваших данный фото-видео -текстового контента - виявите свое заявление перед посещением и использованием нашего сервиса.")
                    .padding(EdgeInsets(top: 36, leading: 16, bottom: 36, trailing: 16))
                    .frame(maxWidth: .infinity)
                    .padding(10)
            }
            
            
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
/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreen().environmentObject(SignInVM())
    }
}
 */
