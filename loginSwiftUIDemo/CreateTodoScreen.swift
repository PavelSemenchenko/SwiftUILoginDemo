//
//  CreateTodoScreen.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 28.06.2023.
//

import SwiftUI
import Combine

struct CreateTodoScreen: View {
    private (set) var todo: Todo?
    @Environment(\.dismiss) var dismiss
    @ObservedObject var todosVM = TodoVM()
    @State private var currentTitle = ""
    @State private var isKeyboardVisible = false
    
    @ObservedObject private var keyboardResponder = KeyboardResponder()

    var keyboardHeight: CGFloat {
        keyboardResponder.keyboardHeight
    }

    
    
    var body: some View {
        VStack {
            TextField("Type title here", text: $currentTitle)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 1)
                )
                .background(Color.gray)
                        .cornerRadius(8)
                        .padding(.bottom, isKeyboardVisible ? keyboardHeight : 0)
            
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
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                    isKeyboardVisible = true
                }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notification in
                    isKeyboardVisible = false
                }
            }
        
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.2, green: 0.0, blue: 0.2,  opacity: 0.3 ))
    }
}

final class KeyboardResponder: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var keyboardHeight: CGFloat = 0
    
    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { notification in
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            }
            .map { rect in
                rect.height
            }
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in 0 }
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellables)
    }
}

struct CreateTodoScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreateTodoScreen()
    }
}
