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
            List(followersVM.followers) { item in
                Text(item.name)
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
        
        let snapshot = try? await
        Firestore.firestore().collection("followers").whereField("userId2", isEqualTo: userId).getDocuments()
        
        let followers = snapshot?.documents.map { $0.data()["userId2"] as? String}.compactMap { $0 }
        
        guard let followers = followers, !followers.isEmpty else {
            return
        }
        
        let snapshot2 = try? await
        Firestore.firestore().collection("people").whereField("userId2", in: followers).getDocuments()
        
        let contacts = snapshot2?.documents.map { doc in
            try! doc.data(as: Contact.self)
        }.compactMap { $0 }
        
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

