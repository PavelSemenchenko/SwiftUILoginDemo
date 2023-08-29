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
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
