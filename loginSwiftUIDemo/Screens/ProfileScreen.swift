//
//  ProfileScreen.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 04.10.2023.
//

import SwiftUI

struct ProfileScreen: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("user nickname")
                    .badge(3)
                    .fontWeight(.bold)
                    .padding()
                Spacer()
                Button(action: {}, label: {
                    Image(systemName: "plus.app")
                        .foregroundColor(.black)
                }).padding()
                Button(action: {}, label: {
                    Image(systemName: "text.justify")
                        .foregroundColor(.black)
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
                    }.padding()
                    VStack {
                        Text("97")
                            .fontWeight(.bold)
                        Text("Posts")
                    }
                    VStack {
                        Text("239")
                            .fontWeight(.bold)
                        Text("Followers")
                    }
                    VStack {
                        Text("725")
                            .fontWeight(.bold)
                        Text("Following")
                    }
                
            }
            Text("user name").padding()
            Button(action: {}) {
                Text("Edit profile")
                    .foregroundColor(.black)
                
            }.frame(maxWidth: .infinity)
                .frame(height: 32)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(10)
         Spacer()
        }
    }
}

#Preview {
    ProfileScreen()
}
