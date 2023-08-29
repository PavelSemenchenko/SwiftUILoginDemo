//
//  TodosScreen.swift
//  loginSwiftUIDemo
//
//  Created by mac on 20.06.2023.
//

import SwiftUI

struct TodosScreen: View {
    @State var todosCount = 0
    @State var todos: [Todo]?
    @State var visible = true // keyboard
    @State var wellcomeText: String? = nil
    @EnvironmentObject private var loginVM: SignInVM
    @EnvironmentObject private var todosVM: TodoVM
    @EnvironmentObject private var navigationVM: NavigationRouter
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 20) {
                NavigationLink(value: NavigationRoute.createTodo) {
                    Image(systemName: "square.and.pencil")
                }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                Spacer()
                Text("Todos").font(.headline).padding(5)
                Spacer()
                
                /*
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
                 }*/
                
                Button(action: {
                    loginVM.logOut()
                    navigationVM.pushScreen(route: .signIn)
                }) {
                    Image(systemName: "eject.circle")
                }
                .frame(alignment: .trailing)
            }.padding(5)
                .onReceive(todosVM.todos) { items in
                    todosCount = items.count
                    todos = items
                }
            
            HStack(alignment: .top) {
                Text("All todo :")
                    //.font(.title2)
                    .bold()
                    .padding(.leading,20)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                
            }
            
            if let todos = todos {
                if todos.isEmpty {
                    Text("There is no todos,create one ..")
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .multilineTextAlignment(.center)
                    Spacer()
                } else {
                    List(todos) { currentTodo in
                        HStack {
                            Image(systemName: "list.bullet.rectangle.fill")
                                .frame(width: 30, height: 30, alignment: .leading)
                                .padding(1)
                            
                            VStack(alignment: .leading) {
                                Text(currentTodo.id!)
                                    .font(.footnote)
                                    .font(.system(size: 8))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                //.multilineTextAlignment(.leading)
                                    .lineLimit(1)
                                    .frame(height: 10)
                                Text(currentTodo.title)
                                    .lineLimit(1)
                            }
                            NavigationLink(value: NavigationRoute.editTodo(todo: currentTodo)) {
                                //Image(systemName: "pencil.line")
                            }.buttonStyle(PlainButtonStyle())
                                .fixedSize()
                        }
                        .frame(minHeight: 46, maxHeight: 46)
                        .swipeActions {
                            
                            Button(action: {
                                deleteTodo(currentTodo)
                            }) {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                            
                            Button(action: {
                                navigationVM.pushScreen(route: .editTodo(todo: currentTodo))
                            }) {
                                Image(systemName: "pencil")
                            }
                            .tint(.blue)
                        }
                    }//.padding(.bottom, 1)
                    //.listStyle(PlainListStyle())
                }
                
                
                
            } else {
                VStack{
                    Spacer()
                    HStack {
                        Spacer()
                        ProgressView()
                        Text("absent data")
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor(red: 0.9, green: 0.48, blue: 0.33, alpha: 1.0)))
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
            .environmentObject(TodoVM())
            .environmentObject(NavigationRouter())
    }
}
