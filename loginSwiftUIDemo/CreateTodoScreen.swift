//
//  CreateTodoScreen.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 28.06.2023.
//

import SwiftUI

struct CreateTodoScreen: View {
    private (set) var todo: Todo?
    @Environment(\.dismiss) var dismiss
    @ObservedObject var todosVM = TodoVM()
    @State private var currentTitle = ""
    
    var body: some View {
        VStack {
            TextField("Type title here", text: $currentTitle)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 1)
                )
            Button("Save") {
                guard currentTitle.count >= 3 else {
                    return
                }
                Task {
                    if let id = todo?.id {
                        await todosVM.update(id: id, title: currentTitle)
                    } else {
                        await todosVM.create(title: currentTitle)
                    }
                }
                dismiss()
            }
        }.padding()
            .onAppear {
                self.currentTitle = todo?.title ?? ""
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.2, green: 0.0, blue: 0.2,  opacity: 0.3 ))
    }
}

struct CreateTodoScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreateTodoScreen()
    }
}
