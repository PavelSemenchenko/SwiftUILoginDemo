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
    
    let settings: [Setting] = [
        Setting(name: "Сменить язык"),
        Setting(name: "Использовать промокод"),
        Setting(name: "Cтать премиум участником"),
        Setting(name: "Подписывайтесь на нас в Instagram"),
        Setting(name: "Выйти")
    ]
    
    var body: some View {
        NavigationView {
            List(settings) { item in
                NavigationLink(destination: destinationView(for: item)) {
                    SettingsRow(settings: item)
                }
            }
            .navigationBarTitle("Настройки")
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
            })
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
