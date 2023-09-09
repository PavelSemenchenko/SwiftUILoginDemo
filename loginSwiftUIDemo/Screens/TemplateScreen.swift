//
//  TemplateScreen.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 29.08.2023.
//

import SwiftUI

struct TemplateScreen: View {
    @EnvironmentObject private var navigationVM: NavigationRouter
    @EnvironmentObject private var loginVM: SignInVM
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack{
            HStack{
                Image(colorScheme == .light ? "lb" : "lw")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .padding(1)
                
                Spacer()
                
                Button(action: {
                    loginVM.logOut()
                    navigationVM.pushScreen(route: .signIn)
                }) {
                    Image(systemName: "eject.circle")
                }
                .frame(alignment: .trailing)
                .padding()
            }
            
            Spacer()
            
            VStack{
                Text("Hello, User!").padding()
                
                Image("empty_user")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(.gray, lineWidth: 4)
                    }.shadow(radius: 7)
                    .padding(.bottom, 15)
                
                
            }
            Spacer()
            ScrollView(.horizontal) {
                HStack{
                    Spacer()
                    MentorView(name: "Doc first", imageName: "psy1")
                    Spacer()
                    MentorView(name: "Doc second", imageName: "psy2")
                    Spacer()
                    MentorView(name: "Doc third", imageName: "psy3")
                    Spacer()
                    MentorView(name: "Doc forth", imageName: "psy4")
                }
            }
            .scrollIndicators(.hidden)
            Spacer()
        }
    }
}

struct MentorView: View {
    let name: String
    let imageName: String
    
    var body: some View {
        VStack {
            Text(name)
                .padding(5)
            Image(imageName)
                .resizable()
                .frame(width: 128, height: 128)
            Button("Talk") {
                
            }.padding(5)
        }.background(RoundedRectangle(cornerRadius: 16)
            .stroke(Color.blue, lineWidth: 2))
    }
}

struct TemplateScreen_Previews: PreviewProvider {
    static var previews: some View {
        TemplateScreen()
    }
}
