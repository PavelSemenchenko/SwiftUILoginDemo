//
//  TapBar.swift
//  loginSwiftUIDemo
//
//  Created by mac on 18.06.2023.
//

import Foundation
import SwiftUI


struct TabBar: View {
    
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
            .padding(.horizontal, 20)
            .background(Color(.cyan))  
    
    }*/
    var body: some View {
            TabView {
                // Вкладка 1
                Text("Вкладка 1")
                    .tabItem {
                        Image(systemName: "1.square.fill")
                        Text("Вкладка 1")
                    }
                
                // Вкладка 2
                Text("Вкладка 2")
                    .tabItem {
                        Image(systemName: "2.square.fill")
                        Text("Вкладка 2")
                    }
                
                // Вкладка 3
                Text("Menu")
                    .tabItem {
                        Image(systemName: "3.square.fill")
//                        Text("Вкладка 3")
                    }
                Text("Menu")
                    .tabItem {
                        Image(systemName: "4.square.fill")
                        Text("Вкладка 4")
                    }
            }
        }
}

struct STabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
