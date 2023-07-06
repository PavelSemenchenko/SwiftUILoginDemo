//
//  TodosScreen.swift
//  loginSwiftUIDemo
//
//  Created by mac on 20.06.2023.
//

import SwiftUI

struct TodosScreen: View {
    
    var todosVM = TodoVM()
    @State var todosCount = 0
    @State var todos: [Todo] = []
    @State var visible = true
    @State var wellcomeText: String? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                NavigationLink {
                    CreateTodoScreen(todo: nil)
                } label: {
                    Image(systemName: "square.and.pencil")
                }
                
                Button("change") {
                    visible.toggle()
                }
                if visible {
                    Text("U can see")
                } else {
                    Text("hidden").hidden()
                }
                
                Button("Hi") {
                    wellcomeText = "Pressed hi !"
                }
                if wellcomeText != nil {
                    Text(wellcomeText!)
                }
                
            }.padding(15)
            HStack {
                Text("All todo :").font(.largeTitle).bold()
                    .padding(.leading,20)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                Text("\(todosCount)").onReceive(todosVM.todos) { items in
                    todosCount = items.count
                    todos = items
                }.padding(.trailing, 20)
            }
            if todos.isEmpty {
                Text("There is no todos,create one ..")
            } else {
                List {
                    ForEach(todos) { currentTodo in
                        HStack {
                            Text(currentTodo.title ?? "--")
                            
                            NavigationLink {
                                CreateTodoScreen(todo: currentTodo)
                            } label: {
                                Image(systemName: "pencil")
                            }
                            .buttonStyle(PlainButtonStyle())
                            .fixedSize()
                        }
                        .frame(maxHeight: 46)
                        .swipeActions {
                            Button(action: {
                                deleteTodo(currentTodo)
                            }) {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                        }
                    }
                }
            }
            
            
            Text("иначе таблица скрывает таббар")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //.edgesIgnoringSafeArea(.all)
        .background(Color(red: 0.2, green: 0.0, blue: 0.2,  opacity: 0.4 ))
    }
    
    func deleteTodo(_ todo: Todo) {
            guard let id = todo.id else {
                return
            }
            
            Task {
                await todosVM.delete(id: id)
            }
        }
}

struct TodosScreen_Previews: PreviewProvider {
    static var previews: some View {
        TodosScreen()
    }
}
