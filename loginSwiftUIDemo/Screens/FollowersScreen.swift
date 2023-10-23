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
    @ObservedObject var followersVM: FollowersVM = FollowersVM()
    
    var body: some View {
        VStack {
            Text("Followers").font(.headline).padding(5)
            EndlessList(vm: followersVM) { item in
                CommonUserItem(item: item)
            }
        }
        //.frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor(red: 0.97, green: 0.33, blue: 0.5, alpha: 1.0)))
    }
}


class FollowersVM: BaseListVM {
    
    @Published var items: [Contact]? = nil
    @Published var emptyText: String? = nil
    @Published var errorText: String? = nil
        
    func loadData(userId: String) async throws -> [Contact] {
        
        let snapshot = try? await
        Firestore.firestore().collection("followers")
            .whereField("userId1", isEqualTo: userId).getDocuments()
        // получили доступные документы по моему id
        
        let followers = snapshot?.documents.map { $0.data()["userId2"] as? String}.compactMap { $0 }
        // получили список id2
        
        guard let followers = followers, !followers.isEmpty else {
            return []
        }
        
        let snapshot2 = try? await
        Firestore.firestore().collection("people")
            .whereField("userId", in: followers).getDocuments()
        // доступ к people у которых id = id2 нашего списка
        
        let contacts = snapshot2?.documents.map { doc in
            try! doc.data(as: Contact.self)
        }.compactMap { $0 }
        // разобрали список отфильтрованных пользователей по формату контактов
        print("contacts are : =========  \(contacts!)")
        return contacts ?? []
        
    }
}

struct FollowersScreen_Previews: PreviewProvider {
    static var previews: some View {
        FollowersScreen()
    }
}

