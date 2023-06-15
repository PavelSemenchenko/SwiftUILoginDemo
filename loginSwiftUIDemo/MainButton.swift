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
    let action: () -> Void
    
    private var color: Color {
        var color: Color = enabled ? .blue : .red
        if busy {
            color = .orange
        }
        return color
    }
    
    var body: some View {
        Button(text, action: action)
            .buttonStyle(MainButtonStyle(color: color))
            .disabled(!enabled || busy)
    }
}

