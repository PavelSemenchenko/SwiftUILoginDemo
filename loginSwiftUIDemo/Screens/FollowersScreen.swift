//
//  FollowersScreen.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 22.08.2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift

struct FollowersScreen: View {
    @StateObject var followersVM: FollowersVM = FollowersVM()
    
    var body: some View {
        VStack {
            Text("Followers").font(.headline).padding(5)
            
            List(followersVM.items ) { item in
                HStack {
                    Text(item.name).padding()
                    Spacer()
                    Button(item.status == .followed ? "Unfollow" : "Follow") {
                        followersVM.pendContact(userId: item.id!)
                        Task {
                            if item.status == .followed {
                                await followersVM.unFollow(userId: item.id!)
                            } else {
                                await followersVM.follow(userId: item.id!)
                            }
                        }
                    }.disabled(item.status == .pending)
                        .padding(10)
                        .frame(width: 100, height: 30)
                        .background(
                            RoundedRectangle(cornerRadius: item.status == .followed ? 10 : 10) // Скругленные края и фон
                                .fill(item.status == .followed ? Color.blue : Color.white) // Фон
                        )
                        .foregroundColor(
                            item.status == .followed ? Color.white : Color.blue // Цвет текста
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: item.status == .followed ? 10 : 10) // Скругленные края (если нужно)
                                .stroke(item.status == .followed ? Color.blue : Color.blue, lineWidth: 2) // Граница (если нужно)
                        )
                    
                        
                        
                }
            }
           // Spacer()
        }.task {
            await followersVM.load()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor(red: 0.97, green: 0.33, blue: 0.5, alpha: 1.0)))
    }
}


class FollowersVM: ObservableObject {
    @Published var items: [SocialContact] = []
   // @Published private(set) var followers: [SocialContact] = []
    
    @MainActor func load() async {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            fatalError("You need to be authenticated")
        }
        // получили свой id
        
        let snapshot = try? await
        Firestore.firestore().collection("followers")
            .whereField("userId1", isEqualTo: userId).getDocuments()
        // получили доступные документы по моему id
        
        let followers = snapshot?.documents.map { $0.data()["userId2"] as? String}.compactMap { $0 }
        // получили список id2
        
        guard let followers = followers, !followers.isEmpty else {
            items = []
            return
        }
        // проверили на пустоту
        print(followers)
        
        let snapshot2 = try? await
        Firestore.firestore().collection("people").whereField("userId", in: followers).getDocuments()
        // доступ к people у которых id = id2 нашего списка
        
        let contacts = snapshot2?.documents.map { doc in
            try! doc.data(as: SocialContact.self)
        }.compactMap { $0 }
        // разобрали список отфильтрованных пользователей по формату контактов
        
        guard let contacts = contacts, !contacts.isEmpty else {
            items = []
            return
        }
        
        // получаем значение подписан или нет
        let snapshot3 = try? await
        Firestore.firestore().collection("followings")
            .whereField("userId1", isEqualTo: userId)
            .whereField("userId2", in: followers).getDocuments()
        
        let following = snapshot3?.documents.map { $0.data()["userId2"]
            as? String}.compactMap { $0 } ?? []
        
        items = contacts.map {
            var contact = $0
            contact.status = following.contains(contact.id!) ? .followed : .none
            return contact
        }
    }
    
    func pendContact(userId: String) {
        items = items.map {
            if $0.id == userId {
                var contact = $0
                contact.status = .pending
                return contact
            }
            return $0
        }
    }
    
    @MainActor func follow(userId: String) async {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            fatalError("not authenticated")
        }
        try? await Firestore.firestore().collection("followings")
            .addDocument(data: ["userId1" : currentUserId, "userId2" : userId])
        
        items = items.map {
            if $0.id == userId {
                var contact = $0
                contact.status = .followed
                return contact
            }
            return $0
        }
    }
    
    @MainActor func unFollow(userId: String) async {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            fatalError("not authenticated")
        }
        let snapshot = try? await Firestore.firestore().collection("followings")
            .whereField("userId1", isEqualTo: currentUserId)
            .whereField("userId2", isEqualTo: userId).getDocuments()
        let documents = snapshot?.documents.map { $0.documentID }
        
        guard let documents = documents, !documents.isEmpty else {
            return
        }
        for doc in documents {
            try? await Firestore.firestore().collection("followings").document(doc).delete()
        }
        
        items = items.map {
            if $0.id == userId {
                var contact = $0
                contact.status = .none
                return contact
            }
            return $0
        }
    }
    
}

struct FollowersScreen_Previews: PreviewProvider {
    static var previews: some View {
        FollowersScreen()
    }
}

