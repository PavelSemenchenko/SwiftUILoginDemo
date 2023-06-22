//
//  TodoVM.swift
//  loginSwiftUIDemo
//
//  Created by mac on 20.06.2023.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift

struct Todo: Codable {
    let title: String
}

class TodoVM: ObservableObject {
    
    //    subscribe to recive updates
    let todos: AnyPublisher<[Todo], Error> = Firestore.firestore().collection("todos")
        .snapshotPublisher()
        .map {snapshot in
            snapshot.documents.map { doc in
                try? doc.data(as: Todo.self)
            }.compactMap { $0 }
        }.eraseToAnyPublisher()
    
    @MainActor func delete(id: String) async {
        try? await Firestore.firestore().collection("todos")
            .document(id)
            .delete()
    }
    @MainActor func update(id: String, title: String) async {
        try? Firestore.firestore().collection("todos")
            .document(id)
            .setData(from: Todo(title: title))
    }
    
    @MainActor func create(title: String) async {
        try? Firestore.firestore().collection("todos")
            .addDocument(from: Todo(title: title))
    }
    
//    ----- or ------
    
//    read data once
    @Published var items: [Todo] = []
    
    @MainActor func load() async {
        let snapshot = try? await Firestore.firestore().collection("todos").getDocuments()
        let todos = snapshot?.documents.map { doc in
            try? doc.data(as: Todo.self)
        }.compactMap { $0 }
        items = todos ?? []
    }
}
