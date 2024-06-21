//
//  SettingsView.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 17.09.2023.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var navigationVM: NavigationRouter
    @EnvironmentObject private var loginVM: SignInVM
    @Environment(\.presentationMode) var presentationMode
    @Binding var tab: TabBarId
    @State private var isAlertPresented = false
    
    let settings: [Setting] = [
        Setting(name: "Сменить язык"),
        Setting(name: "Использовать промокод"),
        Setting(name: "Cтать премиум участником"),
        Setting(name: "Подписывайтесь на нас в Instagram"),
        Setting(name: "Выйти")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("This is a list")) {
                        ForEach(settings) { item in
                            NavigationLink(destination: destinationView(for: item)) {
                                SettingsRow(settings: item)
                            }
                        }
                    }
                    Section(header: Text("This is a second")) {
                        Text("first")
                        Text("second")
                    }
                    Section(header: Text("About")) {
                        Button(action: {
                            isAlertPresented = true
                        }) {
                            Text("ver.  0.0.1")
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                }
            }
            .navigationBarTitle("Настройки")
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
            })
        }.alert(isPresented: $isAlertPresented) {
            Alert(title: Text("woow"), message: Text("Это тестовая версия"), dismissButton: .default(Text("OK")))
        }
    }
    
    @ViewBuilder
    private func destinationView(for setting: Setting) -> some View {
        if setting.name == "Сменить язык" {
            LanguageSelectionView()
        } else if setting.name == "Подписывайтесь на нас в Instagram" {
            Button(action: {
                if let url = URL(string: "https://www.instagram.com/leksovich/") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("Открыть Instagram")
                    .foregroundColor(.blue)
            }
            .buttonStyle(PlainButtonStyle())
        } else if setting.name == "Выйти"{
            Button(action: {
                loginVM.logOut()
                presentationMode.wrappedValue.dismiss()
                navigationVM.pushScreen(route: .signIn)
            }) {
                Text("Уверены, что желаете выйти ? \n \n Выйти")
                    .foregroundColor(.red)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(tab: .constant(.home))
    }
}
