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
    @State private var keyboardHeight: CGFloat = 0

    var body: some View {
        VStack {
            Text("Enter new todo :")
                .fontWeight(.bold)
                .padding(.bottom)
            TextEditor(text: $currentTitle)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.indigo, lineWidth: 2)
                )
                .background(Color.white)
                        .cornerRadius(8)
                        .frame(minHeight: 50, maxHeight: 150)
                        .fixedSize(horizontal: false, vertical: true)
            
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
        }.onTapGesture {
            keyboardResponder.hideKeyboard()
        }
            .padding()
            .padding(.bottom, keyboardHeight)
            .onReceive(keyboardResponder.key1boardHeight, perform: { height in
                keyboardHeight = height - 180
            })
            .onAppear {
                self.currentTitle = todo?.title ?? ""
            }
        
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.2, green: 0.0, blue: 0.2,  opacity: 0.3 ))
            .ignoresSafeArea(.keyboard)
    }
}

final class KeyboardResponder: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var keyboardHeight: CGFloat = 0
    
    
    // поток прослушивания когда клавиатура видима
    lazy var keyboardHeightActive: AnyPublisher<CGFloat, Never> = {
        return NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { notification in
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            }
            .map { rect in
                rect.height
            }.eraseToAnyPublisher()
    }()
    
    // поток прослушивания когда клавиатура НЕ видима
    lazy var keyboardHeightInactive: AnyPublisher<CGFloat, Never> = {
        return NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { rect in
                0
            }.eraseToAnyPublisher()
    }()
    
    lazy var key1boardHeight: AnyPublisher<CGFloat, Never> = {
        keyboardHeightActive.merge(with: keyboardHeightInactive).eraseToAnyPublisher()
    }()
    
    init() {
        
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}



struct CreateTodoScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreateTodoScreen()
            .environmentObject(NavigationRouter())
    }
}
