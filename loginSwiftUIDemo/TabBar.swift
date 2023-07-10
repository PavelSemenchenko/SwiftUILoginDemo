//
//  TapBar.swift
//  loginSwiftUIDemo
//
//  Created by mac on 18.06.2023.
//

import Foundation
import SwiftUI

struct TabBar: View {
    @Binding var currentRoute: NavigationRoute
    @State var selected = 0
    /*

    var body: some View {
        HStack {
            Button(action: {
                self.selected = 0
            }) {
                Image(systemName: "house")
            }.foregroundColor(self.selected == 0 ? .black : .gray)
            
            Spacer()
            
            Button(action: {
                self.selected = 1
            }) {
                Image(systemName: "message.fill")
            }.foregroundColor(self.selected == 1 ? .black : .gray)
            
            Spacer(minLength: 60)
            
            Button(action: {
                self.selected = 2
            }) {
                Image(systemName: "bolt.horizontal.fill")
            }.foregroundColor(self.selected == 2 ? .black : .gray)
            
            Spacer()
            
            Button(action: {
                self.selected = 3
            }) {
                Image(systemName: "line.3.horizontal")
            }.foregroundColor(self.selected == 3 ? .black : .gray)
        }.padding()
            .padding(.bottom, 10)
            .background(Color(.cyan))
        
    }
    
}
*/
    @Environment(\.navigationRouter) var navigationRouter : NavigationRouter
    
    var body: some View {
            TabView {
                // Вкладка 1
                Text("0")
                    .tabItem {
                        Image(systemName: "house")
                        NavigationLink("Login") {
//                            SignUpScreen(navigationRouter: $currentRoute)
                        }
//                        Text("Вкладка 1")
                    }
                
                // Вкладка 2
                Text("1")
                    .tabItem {
                        Image(systemName: "message.fill")
//                        NavigationLink("Create account") {
//                            SignUpScreen()
//                        }
//                        NavigationLink("Перейти на второй экран", destination: TodosScreen()) // Переход на второй экран
                                       
//                        Text("Вкладка 2")
                    }
                
                // Вкладка 3
                Text("2")
                    .tabItem {
                        Image(systemName: "bolt.horizontal.fill")
//                        Text("Вкладка 3")
                    }
                Text("3")
                    .tabItem {
                        Image(systemName: "line.3.horizontal")
                        NavigationLink("Todo") {
//                            TodosScreen()
                        }
//                        Text("Вкладка 4")
                    }
            }.background(Color.green)
        }
}
/*
struct STabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(currentRoute: $currentRoute)
    }
}*/
