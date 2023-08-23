//
//  FollowersScreen.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 22.08.2023.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift

struct FollowersScreen: View {
    @StateObject var followersVM: FollowersVM = FollowersVM()
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Button("load followers", action: {
                Task {
                    await FollowersVM().load()
                }
            })
            List( followersVM.followers ) { contacts in
                Text(contacts.name)
            }
        }
    }
}


class FollowersVM: ObservableObject {
    @Published private(set) var followers: [Contact] = []
    
    func load() async {
        
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
            return
        }
        // проверили на пустоту
        print(followers)
        
        let snapshot2 = try? await
        Firestore.firestore().collection("people").whereField("userId", in: followers).getDocuments()
        // доступ к people у которых id = id2 нашего списка
        
        let contacts = snapshot2?.documents.map { doc in
            try! doc.data(as: Contact.self)
        }.compactMap { $0 }
        // разобрали список отфильтрованных пользователей по формату контактов
        
        guard let contacts = contacts, !contacts.isEmpty else {
            return
        }
        print(contacts)
    }
    
}

struct FollowersScreen_Previews: PreviewProvider {
    static var previews: some View {
        FollowersScreen()
    }
}

