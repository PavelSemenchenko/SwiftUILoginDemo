//
//  PasswordField.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 07.08.2023.
//

import Foundation
import SwiftUI

struct PasswordField: View {
    var valid: Bool
    var placeholder: String
    @Binding var text: String
    private var backgroundColor: Color {
        valid ? .white : .red
    }
    
    var body: some View {
        SecureField(placeholder, text: $text)
            .border(backgroundColor)
            .cornerRadius(5)
            .textFieldStyle(.roundedBorder)
            .padding(EdgeInsets(top: 8, leading: 36, bottom: 8, trailing: 36))
    }
}
