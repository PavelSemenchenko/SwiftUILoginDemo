//
//  LanguageSelectionView.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 17.09.2023.
//

import SwiftUI

struct LanguageSelectionView: View {
    var body: some View {
        
        VStack {
            Button {
                
            } label: {
                Text("🇺🇸 EN")
            }.padding()
            
            Button {
                
            } label: {
                Text("🇺🇦 UA")
            }

            Spacer()
        }.navigationTitle("Выбор языка")
    }
}
struct LanguageSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageSelectionView()
    }
}
