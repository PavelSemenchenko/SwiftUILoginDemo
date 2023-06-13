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
    let busy: Bool
    
    private var color: Color {
        var color: Color = enabled ? .blue : .red
        if busy {
            color = .orange
        }
        return color
    }
    
    var body: some View {
        Button(text) {
            
        }.buttonStyle(MainButtonStyle(color: color))
            .disabled(!enabled || busy)
    }
}

struct MainButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MainButton(text: "Enter", enabled: true, busy: false)
            MainButton(text: "Enter", enabled: false, busy: false)
            MainButton(text: "Enter", enabled: true, busy: true)
            MainButton(text: "Enter", enabled: false, busy: true)
        }
    }
}
