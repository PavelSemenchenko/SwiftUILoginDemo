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
    @State var items: [Contact]? = []
    @State var emptyText: String? = "No folloeings"
    @State var errorText: String? = nil
    var body: some View {
        VStack {
            Text("Followings").font(.headline).padding(5)
            
            EndlessList(items: $items,
                        empty: $emptyText,
                        error: $errorText,
            loadMore: {
                
            }, refresh: {
                
            }, content: { item in
                CommonUserItem(item: item) {
                    followingsVM.unfollow(userId: item.id!)
                }
            })
            /*
            List(followingsVM.items) { item in
                HStack {
                    Text(item.name).padding()
                    Spacer()/*
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
                            .stroke(Color.blue, lineWidth: 2))*/
                    FollowButton(userId: item.id!, status: .followed, loading: false) {
                        followingsVM.unfollow(userId: item.id!)
                    }
                }
            } */
        }.task {
            await followingsVM.load()
        }
        .background(Color(UIColor(red: 0.3, green: 0.8, blue: 0.5, alpha: 1.0)))
        
    }
}

class FollowingsVM : ObservableObject {
    @Published var items: [Contact] = []
    
    @MainActor func load() async {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            fatalError("need authentication")
        }
        
        let snapshot = try? await Firestore.firestore().collection("following")
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
            try? $0.data(as: Contact.self)
        }.compactMap { $0 } ?? []
        
        items = contacts
    }
    
    
    func unfollow(userId: String) {
        items = items.filter { $0.id != userId }
        
    }
}

struct FollowingScreen_Previews: PreviewProvider {
    static var previews: some View {
        FollowingScreen()
    }
}
