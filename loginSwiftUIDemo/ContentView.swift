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

struct ContentView: View {
    let textFieldPadding = EdgeInsets(top: 8, leading: 32, bottom: 8, trailing: 32)
    
    @ObservedObject private var loginVM = SignInVM()
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
    
    private var signInButtonStyle: some ButtonStyle {
        var color: Color = !loginVM.canLogin ? .red : .blue
        if loginVM.loginActive {
            color = .orange
        }
        return BlueButton(color: color)
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
                TextField("Email", text: $loginVM.email)
                    .border(emailBackgroung)
                    .foregroundColor(.white)
                TextField("Password", text: $loginVM.password)
                    .border(passwordBackground)
                    .foregroundColor(.white)
                Button("Sign in") {
                    Task {
                        await loginVM.login()
                    }
                }.buttonStyle(signInButtonStyle)
                    .disabled(!loginVM.canLogin || loginVM.loginActive)
                    .padding()
                
                VStack {
                    NavigationLink("window 2 ", destination: AnotherView2())
                        .foregroundColor(.white)
                    HStack {
                        Text("label 1")
                        Text("label 2")
                    }
                    HStack {
                        Text("label 3")
                        Text("label 4")
                    }
                    //                going to another page
                    Button("Agreements") {
                        isShowingModal.toggle()
                    }.sheet(isPresented: $isShowingModal) {
                        AnotherView()
                    }.navigationBarTitle("Entering")
                    
                }
            }   .padding(20)
                .background(Color.gray).opacity(0.9)
                .border(.black)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
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
        ContentView()
    }
}
