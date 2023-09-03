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
    @StateObject var followingsVM: FollowingsVM = FollowingsVM()
    var body: some View {
        VStack {
            Text("Followings").font(.headline).padding(5)
            List(followingsVM.items) { item in
                HStack {
                    Text(item.name).padding()
                    Spacer()
                    Button(item.status == .followed ? "Unfollow" : "Wait ..") {
                        followingsVM.pendContact(userId: item.id!)
                        Task {
                            await followingsVM.unfollow(userId:item.id!)
                        }
                    }.disabled(item.status != .followed)
                        .foregroundColor(.blue)
                        .padding(10)
                        .frame(width: 100, height: 30)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2))
                        
                }
            }
        }.task {
            await followingsVM.load()
        }
        .background(Color(UIColor(red: 0.3, green: 0.8, blue: 0.5, alpha: 1.0)))
        
    }
}

class FollowingsVM : ObservableObject {
    @Published var items: [SocialContact] = []
    
    @MainActor func load() async {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            fatalError("need authentication")
        }
        
        let snapshot = try? await Firestore.firestore().collection("followings")
            .whereField("userId1", isEqualTo: currentUserId).getDocuments()
        
        let followings = snapshot?.documents.map {
            $0.data()["userId2"] as? String
        }.compactMap { $0 } ?? []
        
        guard !followings.isEmpty else {
            items = []
            return
        }
        
        let snapshot2 = try? await Firestore.firestore().collection("people")
            .whereField("userId", in: followings).getDocuments()
        
        let contacts = snapshot2?.documents.map {
            try? $0.data(as: SocialContact.self)
        }.compactMap { $0 } ?? []
        
        items = contacts.map {
            var contact = $0
            contact.status = .followed
            return contact
        }
        print("founded this \(items)")
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
    
    @MainActor func unfollow(userId: String) async {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            fatalError("need authentication")
        }
        let snapshot = try? await Firestore.firestore().collection("followings")
            .whereField("userId1", isEqualTo: currentUserId)
            .whereField("userId2", isEqualTo: userId).getDocuments()
        
        //находим идентификатор документа который нужно удалить
        let documencts = snapshot?.documents.map { $0.documentID }
        
        guard let documencts = documencts, !documencts.isEmpty else {
            return
        }
        
        for doc in documencts {
            try? await Firestore.firestore().collection("followings").document(doc).delete()
        }
        
        items = items.filter { $0.id != userId }
        
    }
}

struct FollowingScreen_Previews: PreviewProvider {
    static var previews: some View {
        FollowingScreen()
    }
}
