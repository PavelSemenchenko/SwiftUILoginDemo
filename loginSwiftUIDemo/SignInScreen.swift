//
//  ContentView.swift
//  loginSwiftUIDemo
//
//  Created by mac on 05.06.2023.
//

import SwiftUI

struct BlueButton : ButtonStyle {
    let color : Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(color)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

struct SignInScreen: View {
    
    @ObservedObject private var loginVM = SignInVM()
//     var signUp = SignUpScreen()
    // observ another page
    @State private var isShowingModal = false
    //
    private var emailBackgroung : Color {
        loginVM.isEmailCorrect ? .white : .red
    }
    
    private var passwordBackground: Color {
        get {
            if loginVM.isPaswordCorrect {
                return .white
            } else {
                return .red
            }
        }
    }
    
    private var signInButtonColor: Color {
        var color: Color = !loginVM.canLogin ? .red : .blue
        if loginVM.loginActive {
            color = .orange
        }
        return color
    }
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
                    .foregroundColor(.accentColor)
                    .padding(20)
                EditField(valid: loginVM.isEmailCorrect, placeholder: "Email", text: $loginVM.email)
                EditField(valid: loginVM.isPaswordCorrect, placeholder: "Password", text: $loginVM.password)
                
                MainButton(text: "Sign In", enabled: loginVM.canLogin || !loginVM.loginActive, busy: loginVM.loginActive)
                
                
                VStack {
                    HStack {
                        Spacer()
                        NavigationLink("Sign Up", destination: SignUpScreen())
                            .foregroundColor(.white)
                    }
                    Button("Agreements") {
                        isShowingModal.toggle()
                    }.sheet(isPresented: $isShowingModal) {
                        AnotherView()
                    }.navigationBarTitle("Entering")
                        .foregroundColor(.red)
                    
                }
            }   .padding(20)
//                .background(Color.gray).opacity(0.9)
                .border(.black)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            //        описываем отступы содержимого в стеке
            .padding(EdgeInsets(top: 50, leading: 32, bottom: 50 , trailing: 32))
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all))
            .edgesIgnoringSafeArea(.all)
        }
    }
}
//another page in this window
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
        SignInScreen()
    }
}
