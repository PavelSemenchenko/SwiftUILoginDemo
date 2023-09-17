//
//  SettingsContent.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 17.09.2023.
//

import SwiftUI

struct SettingsContent: View {
    
    let settings: [Setting] = [
        Setting(name: "Сменить язык"),
        Setting(name: "Использовать промокод")
    ]
    
    var body: some View {
        NavigationView {
            List(settings) { item in
                NavigationLink(destination: destinationView(for: item)) {
                    SettingsRow(settings: item)
                }
            }
            .navigationBarTitle("Список элементов")
        }
    }
    
    @ViewBuilder
    private func destinationView(for setting: Setting) -> some View {
        if setting.name == "Сменить язык" {
            LanguageSelectionView()
        } else {
            TodosScreen() // Замените на ваше представление для других элементов
        }
    }
}

struct LanguageSelectionView: View {
    var body: some View {
        Text("Выбор языка")
            .navigationBarTitle("Сменить язык")
    }
}

struct SettingsContent_Previews: PreviewProvider {
    static var previews: some View {
        SettingsContent()
    }
}
