//
//  TemplateScreen.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 29.08.2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift

struct TemplateScreen: View {
    @EnvironmentObject private var navigationVM: NavigationRouter
    @EnvironmentObject private var loginVM: SignInVM
    @StateObject private var templateVM = TemplateVM()
    @Environment(\.colorScheme) var colorScheme
    @State private var name: String?
    
    var body: some View {
        VStack(){
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
                if let name = name {
                    Text("Hello,\(name)")
                        .padding()
                        .font(.title)
                        
                } else {
                    Text("Loading ...")
                }
            }.onAppear {
                Task {
                    await templateVM.getName()
                    print(name)
                }
            }
            
            Image("empty_user")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.gray, lineWidth: 4)
                }.shadow(radius: 7)
                .padding(.bottom, 15)
            
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
            Spacer(minLength: 24)
            ScrollView(.vertical) {
                Spacer()
                PlaceView(name: "Heaven", image: "place1")
                Spacer()
                PlaceView(name: "Hell", image: "place2")
                Spacer()
                PlaceView(name: "Earth", image: "place3")
                Spacer()
            }//.padding()
        }
    }
}


class TemplateVM: ObservableObject {
    @Published var name = ""
    @MainActor func getName() async {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            fatalError("You need to be authenticated")
        }
        let snapshot = try? await
        Firestore.firestore().collection("people")
            .whereField("userId", isEqualTo: userId).getDocuments()
        
        let profile = snapshot?.documents.compactMap { $0 }
        
        let contact = snapshot?.documents.map { doc in
            try! doc.data(as: Contact.self)
        }.compactMap { $0 }
        
        
        if let contact = contact?.first {
        }
        let name = contact?.first?.name
        print("found name is \(name!)")
        
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
                .frame(width: 96, height: 86)
            Button("Talk") {
                
            }.padding(5)
        }.background(RoundedRectangle(cornerRadius: 16)
            .stroke(Color.blue, lineWidth: 2))
    }
}

struct PlaceView: View {
    let name: String
    let image: String
    
    var body: some View {
        ZStack {
            
            Image(image)
                .resizable()
            //.aspectRatio(contentMode: .fit)
                .frame(width: 380, height: 128)
                .overlay(
                    Text(name)
                        .foregroundColor(.white)
                        .font(.title)
                        .padding(1)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(8)
                        .padding(10),alignment: .top
                )
            // Spacer()
            Button("Request") {
                
            }.padding(8)
                .background(Color.white.opacity(0.5))
                .cornerRadius(8)
            
        }/*.background(RoundedRectangle(cornerRadius: 16)
          .stroke(Color.blue, lineWidth: 2))*/
    }
}

struct TemplateScreen_Previews: PreviewProvider {
    static var previews: some View {
        TemplateScreen()
    }
}
