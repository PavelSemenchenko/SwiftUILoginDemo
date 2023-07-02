//
//  TodosScreen.swift
//  loginSwiftUIDemo
//
//  Created by mac on 20.06.2023.
//

import SwiftUI

struct TodosScreen: View {
    
    var todosVM = TodoVM()
    @State var todosCount = "---"
    @State var todos: [Todo] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                NavigationLink {
                    CreateTodoScreen(todo: nil)
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }.padding(15)
            HStack {
                Text("All todo :").font(.largeTitle).bold()
                    .padding(.leading,20)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                Text(todosCount).onReceive(todosVM.todos) { items in
                    todosCount = "\(items.count)"
                    todos = items
                }.padding(.trailing, 20)
            }
            List(todos) { currentTodo in
                HStack {
                   // Text(currentTodo.id ?? "--")
                    Text(currentTodo.title ?? "--")
                    
                    NavigationLink {
                        CreateTodoScreen(todo: currentTodo)
                    } label: {
                        Image(systemName: "pencil")
                    }.buttonStyle(PlainButtonStyle()).fixedSize()
                    
                    Button {
                        guard let id = currentTodo.id else {
                            return
                        }
                        Task {
                            await todosVM.delete(id: id)
                        }
                    } label: {
                        Image(systemName: "trash")
                    }.buttonStyle(PlainButtonStyle())
                }
            }
            Text("end of the list")
            
            /*
            ForEach(1..<20) { id in
                Text("Todo# \(id)")
            }.padding(.leading, 30)*/
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //.edgesIgnoringSafeArea(.all)
        .background(Color(red: 0.2, green: 0.0, blue: 0.2,  opacity: 0.4 ))
    }
}

struct TodosScreen_Previews: PreviewProvider {
    static var previews: some View {
        TodosScreen()
    }
}
