//
//  EditField.swift
//  loginSwiftUIDemo
//
//  Created by mac on 12.06.2023.
//

import Foundation
import SwiftUI

struct EditField: View {
    var valid: Bool
    var placeholder: String
    var text: Binding<String>
    private var backgroundColor: Color {
        valid ? .white : .red
    }
    
    var body: some View {
        TextField(placeholder, text: text)
            .border(backgroundColor)
            //.background(backgroundColor)
            .padding(EdgeInsets(top: 8, leading: 36, bottom: 8, trailing: 36))
    }
}

