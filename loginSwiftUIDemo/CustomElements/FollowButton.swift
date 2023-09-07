//
//  FollowButton.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 05.09.2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift

struct FollowButton: View {
    
    let userId: String
    @State var status: FollowStatus = .pending
    @State var loading = true
    var action: (() -> Void)? = nil
    
    var body: some View {
        ZStack{
            if loading {
                ProgressView()
            } else {
                Button(status == .pending ? "Wait" :
                        status == .followed ? "Unfollow" : "Follow") {
                    let currentStatus = status
                    status = .pending
                    Task {
                        guard let currentUserId = Auth.auth().currentUser?.uid else {
                            fatalError("You need to be authenticated")
                        }
                        if currentStatus == .followed {
                            let snapshot = try? await Firestore.firestore().collection("following")
                                .whereField("userId1", isEqualTo: currentUserId)
                                .whereField("userId2", isEqualTo: userId).getDocuments()
                            
                            let documents = snapshot?.documents.map { $0.documentID }
                            
                            guard let documents = documents, !documents.isEmpty else {
                                return
                            }
                            
                            for doc in documents {
                                try? await Firestore.firestore().collection("following")
                                    .document(doc).delete()
                            }
                            status = .none
                        } else if currentStatus == .none {
                            try? await Firestore.firestore().collection("following")
                                .addDocument(data: ["userId1" : currentUserId, "userId2" : userId])
                            
                            status = .followed
                            
                            try? await Firestore.firestore().collection("people")
                                .document(userId).updateData(["userId" : userId])
                             
                        }
                        action?()
                    }
                }.disabled(status == .pending)
            }
        }.task {
            guard let currentUserId = Auth.auth().currentUser?.uid else {
                fatalError("You need to be authenticated")
            }
            
            let snapshot = try? await Firestore.firestore().collection("following")
                .whereField("userId1", isEqualTo: currentUserId)
                .whereField("userId2", isEqualTo: userId).getDocuments()
            
            let following = (snapshot?.documents.count ?? 0) > 0
            status = following ? .followed : .none
            loading = false
        }
    }
}

struct FollowButton_Previews: PreviewProvider {
    static var previews: some View {
        FollowButton(userId: "")
    }
}

