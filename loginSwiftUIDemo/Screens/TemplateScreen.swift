//
//  TemplateScreen.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 29.08.2023.
//

import SwiftUI

struct TemplateScreen: View {
    @EnvironmentObject private var navigationVM: NavigationRouter
    
    var body: some View {
        VStack{
            Text("Hello, User!")
            
            Image("empty_user")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.gray, lineWidth: 4)
                }.shadow(radius: 7)
                .padding(.bottom, 15)
            
            Button("logout"){
                navigationVM.pushScreen(route: .signIn)
            }
        }
    }
}

struct TemplateScreen_Previews: PreviewProvider {
    static var previews: some View {
        TemplateScreen()
    }
}
