//
//  FollowingScreen.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 31.08.2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift

struct FollowingScreen: View {
    @ObservedObject var followingsVM: FollowingsVM = FollowingsVM()
    
    var body: some View {
        VStack {
            Text("Followings").font(.headline).padding(5)
            EndlessList(vm: followingsVM){ item in
                CommonUserItem(item: item) {
                    followingsVM.unfollow(userId: item.id!)
                }
            }
        }
        .background(Color(UIColor(red: 0.3, green: 0.8, blue: 0.5, alpha: 1.0)))
        
    }
}

class FollowingsVM : BaseListVM {
    
    @Published var items: [Contact]? = nil
    @Published var emptyText: String? = nil
    @Published var errorText: String? = nil
    
    func loadData(userId: String) async throws -> [Contact] {
        
        let snapshot = try? await Firestore.firestore().collection("following")
            .whereField("userId1", isEqualTo: userId).getDocuments()
        
        let followings = snapshot?.documents.map {
            $0.data()["userId2"] as? String
        }.compactMap { $0 } ?? []
        
        guard !followings.isEmpty else {
            return []
        }
        
        let snapshot2 = try? await Firestore.firestore().collection("people")
            .whereField("userId", in: followings).getDocuments()
        
        let contacts = snapshot2?.documents.map {
            try? $0.data(as: Contact.self)
        }.compactMap { $0 } ?? []
        
        return contacts
    }
    
    
    func unfollow(userId: String) {
        items = items?.filter { $0.id != userId }
        
    }
}

struct FollowingScreen_Previews: PreviewProvider {
    static var previews: some View {
        FollowingScreen()
    }
}
