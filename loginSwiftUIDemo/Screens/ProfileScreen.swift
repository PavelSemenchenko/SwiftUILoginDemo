//
//  ProfileScreen.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 04.10.2023.
//

import SwiftUI

struct ProfileScreen: View {
    var body: some View {
        VStack {
            HStack {
                Text("user nickname")
                    .fontWeight(.bold)
                    .padding()
                Spacer()
                Button(action: {}, label: {
                    Image(systemName: "plus.app")
                }).padding()
                Button(action: {}, label: {
                    Image(systemName: "text.justify")
                }).padding()
            }
            HStack {
                VStack {
                    Image("empty_user")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay {
                            Circle().stroke(.gray, lineWidth: 4)
                        }.shadow(radius: 7)
                        .padding(5)
                    Text("user name")
                }
                VStack {
                    Text("97")
                    Text("posts")
                }.padding()
                VStack {
                    Text("239")
                    Text("Followers")
                }.padding()
                VStack {
                    Text("725")
                    Text("Following")
                }.padding()
            }
            Button(action: {}) {
                Text("Edit profile")
                    .foregroundColor(.white)
                    
            }.frame(maxWidth: .infinity)
                .frame(height: 32)
                .background(Color.gray.opacity(0.4))
                .cornerRadius(8)
                .padding(10)
                
        }
    }
}

#Preview {
    ProfileScreen()
}
