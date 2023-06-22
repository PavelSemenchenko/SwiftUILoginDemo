//
//  TodosScreen.swift
//  loginSwiftUIDemo
//
//  Created by mac on 20.06.2023.
//

import SwiftUI

struct TodosScreen: View {
    
    var todosVM = TodoVM()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Button("create") {
                    Task {
                        await todosVM.create(title: "doing homework")
                    }
                }
                Button("edit") {
                    Task {
                        await todosVM.update(id: "ZicsJQMjb6J0r992Iejy", title:"has been updated")
                    }
                }
                Button("delete") {
                    Task {
                        await todosVM.delete(id: "ZicsJQMjb6J0r992Iejy")
                    }
                }
            }
            Text("All todo :").font(.largeTitle).bold()
                .padding(.leading,20)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            ForEach(1..<20) { id in
                Text("Todo# \(id)")
            }.padding(.leading, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .background(Color(red: 0.2, green: 0.0, blue: 0.2,  opacity: 0.4 ))
    }
}

struct TodosScreen_Previews: PreviewProvider {
    static var previews: some View {
        TodosScreen()
    }
}
