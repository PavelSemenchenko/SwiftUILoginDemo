//
//  TodosScreen.swift
//  loginSwiftUIDemo
//
//  Created by mac on 20.06.2023.
//

import SwiftUI

struct TodosScreen: View {
    @Binding var currentRoute: NavigationRoute
    var todosVM = TodoVM()
    @State var todosCount = 0
    @State var todos: [Todo]?
    @State var visible = true
    @State var wellcomeText: String? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 20) {
                NavigationLink {
                    CreateTodoScreen(todo: nil, currentRoute: $currentRoute)
                } label: {
                    Image(systemName: "square.and.pencil")
                }
                
                Button("change") {
                    visible.toggle()
                }
                if visible {
                    Text("U can see")
                        .font(/*@START_MENU_TOKEN@*/.headline/*@END_MENU_TOKEN@*/)
                } else {
                    Text("hidden").hidden()
                }
                
                Button("Hi") {
                    wellcomeText = "Pressed hi !"
                }
                if let checkWellcome = wellcomeText {
                    Text(checkWellcome)
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
            
            if let todos = todos {
                if todos.isEmpty {
                    Text("There is no todos,create one ..")
                        .padding()
                } else {
                    List {
                        ForEach(todos) { currentTodo in
                            HStack {
                                Text(currentTodo.title ?? "--")
                                
                                NavigationLink {
                                    CreateTodoScreen(todo: currentTodo, currentRoute: $currentRoute)
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
            } else {
                ProgressView()
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
/*
struct TodosScreen_Previews: PreviewProvider {
    static var previews: some View {
        TodosScreen()
    }
}*/
