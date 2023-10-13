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
    
    @State private var isShowingSettings = false
    @State private var isShowingProfileScreen = false
    @State private var isShowingMessagesScreen = false
    
    // принимаем значение которое заменим
    @Binding var tab: TabBarId
    
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
                    isShowingSettings.toggle()
                }) {
                    HStack {
                        Image(systemName: "gearshape.fill") // Изображение настроек
                            .imageScale(.large)
                            .foregroundColor(.blue) // Цвет изображения
                    }
                }
                
                .fullScreenCover(isPresented: $isShowingSettings) {
                    SettingsView(tab: .constant(.home))
                }
                .padding(8)
            }
            
            
            ScrollView(.vertical) {
                VStack{
                    Text("Hello, \(templateVM.name)")
                        .padding()
                        .font(.system(size: 24,weight: .bold))
                        .onAppear {
                            if templateVM.name == "..." {
                                Task {
                                    await templateVM.getName()
                                    print("Current User ID: \(templateVM.name)")
                                }
                            }
                        }
                }
                HStack{
                    Spacer()
                    Image("empty_user")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay {
                            Circle().stroke(.gray, lineWidth: 4)
                        }.shadow(radius: 7)
                        .padding(.bottom, 15)
                    Spacer()
                        VStack(alignment: .leading){
                            /*
                            Button(action: {
                                tab = .followers
                            }) {
                                Image(systemName: "person.line.dotted.person.fill")
                                Text("Followers")
                            }*/
                            NavigationLink(destination: FollowersScreen()) {
                                Text("Followers")
                            }.environmentObject(FollowersVM())
                            
                            NavigationLink(destination: FollowingScreen()) {
                                Text("Following")
                            }
                            //.environmentObject(FollowingScreen())
                            
                            
                            /*
                            Button(action: {
                                isShowingProfileScreen.toggle()
                            }) {
                                Text("Open Profile binding")
                            }
                            .sheet(isPresented: $isShowingProfileScreen) {
                                ProfileScreen()
                            }
                             */
                            NavigationLink(destination: ProfileScreen()) {
                                Text("Open Profile full")
                            }
                            
                            Button(action: {
                                tab = .todo
                            }) {
                                Text("Todo")
                            }.environmentObject(TodoVM())
                        }
                    
                    Spacer()
                }
                Spacer()
                ScrollView(.horizontal) {
                    HStack{
                        Spacer()
                        MentorView(name: "Doc first", imageName: "psy1")
                            .onTapGesture {
                                isShowingMessagesScreen.toggle()
                            }
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
                }.scrollIndicators(.hidden)
            }.scrollIndicators(.hidden)
        }
        .sheet(isPresented: $isShowingMessagesScreen) {
            MessagesScreen()
        }
    }
}


class TemplateVM: ObservableObject {
    
    @Published var name = "..."
    
    @MainActor func getName() async {
        // получили идентификатор текущего пользователя
        guard let userId = Auth.auth().currentUser?.uid else {
            return print ("John Doe")
            //fatalError("You need to be authenticated")
        }
        
        do {
            // взяли снимок из коллекции с текущим идентификатором пользователя
            let querySnapshot = try await Firestore.firestore()
                .collection("people")
                .whereField("userId", isEqualTo: userId)
                .getDocuments()
            
            // Проверяем, есть ли документы
            guard !querySnapshot.isEmpty else {
                print("No documents found for user with ID: \(userId)")
                return
            }
            
            // Получаем данные первого документа
            if let document = querySnapshot.documents.first {
                // Преобразуем данные документа в объект Contact
                if let contact = try? document.data(as: Contact.self) {
                    // Обновляем значение @Published var name
                    self.name = contact.name ?? "John Doe"
                    self.objectWillChange.send()
                } else {
                    print("Failed to decode Contact from document data")
                }
            } else {
                print("No documents found for user with ID: \(userId)")
            }
        } catch {
            print("Error fetching user data: \(error.localizedDescription)")
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
                .frame(width: 96, height: 86)
            Button("Chat") {
                
            }.padding(5)
        }.background(RoundedRectangle(cornerRadius: 10)
            .stroke(Color.gray, lineWidth: 2))
        .padding(8)
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
                        .padding(6)
                        .font(.title)
                        .padding(1)
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(16)
                        .padding(10)
                    ,alignment: .top
                )
            Spacer()
            Button("Meditate") {
                
            }
            .padding(8)
            .background(Color.white.opacity(0.2))
            .cornerRadius(16)
            .foregroundColor(.white)
            
        }
        .padding(8)
        /*.background(RoundedRectangle(cornerRadius: 16)
         .stroke(Color.blue, lineWidth: 2))*/
    }
}

#Preview("UA") {
    TemplateScreen(tab: .constant(.home))
        .environment(\.locale, Locale(identifier: "UA"))
        .environmentObject(TemplateVM())
}
/*
struct TemplateScreen_Previews: PreviewProvider {
    static var previews: some View {
        TemplateScreen(tab: .constant(.home))
            .environmentObject(TemplateVM())
    }
}*/
