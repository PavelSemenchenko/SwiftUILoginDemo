//
//  MainButton.swift
//  loginSwiftUIDemo
//
//  Created by mac on 12.06.2023.
//

import Foundation
import SwiftUI

fileprivate struct MainButtonStyle: ButtonStyle {
    
    let color: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(color)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

struct MainButton: View {
    let text: String
    let enabled: Bool
    let color: Color
    
    var body: some View {
        Button(text) {
            
        }.buttonStyle(MainButtonStyle(color: color))
            .disabled(!enabled)
    }
}

struct MainButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MainButton(text: "Enter", enabled: true, color: .blue)
            MainButton(text: "Exit", enabled: false, color: .black)
        }
    }
}
