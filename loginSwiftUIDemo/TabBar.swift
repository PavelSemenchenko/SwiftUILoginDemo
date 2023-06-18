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
            
            Spacer(minLength: 120)
            
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
        }.padding(20)
    
    }
}

struct STabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
