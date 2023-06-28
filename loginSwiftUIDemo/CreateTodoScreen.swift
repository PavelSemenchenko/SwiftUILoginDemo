//
//  CreateTodoScreen.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 28.06.2023.
//

import SwiftUI

struct CreateTodoScreen: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var todosVM = TodoVM()
    @State private var currentTitle = ""
    
    var body: some View {
        VStack {
            TextField("Type title here", text: $currentTitle)
            Button("Save") {
                guard currentTitle.count >= 3 else {
                    return
                }
                Task {
                    await todosVM.create(title: currentTitle)
                }
                dismiss()
            }
        }.padding()
    }
}

struct CreateTodoScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreateTodoScreen()
    }
}
