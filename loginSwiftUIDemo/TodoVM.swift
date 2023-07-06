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

struct Todo: Codable, Identifiable {
    @DocumentID var id: String?
    @ServerTimestamp var created: Date?
    let title: String
}

class TodoVM: ObservableObject {
    @Published var editingTitle: String = ""
    
    //    subscribe to recive updates
    let todos: AnyPublisher<[Todo], Never> = Firestore.firestore().collection("todos")
        .order(by: "created")
        .snapshotPublisher(includeMetadataChanges: true)
        .filter { snapshot in
            !snapshot.metadata.isFromCache
        }
        .map {snapshot in
            print("is from cache \(snapshot.metadata.isFromCache)")
            // need return тк больше одной строки
            return snapshot.documents.map { doc in
                try? doc.data(as: Todo.self)
            }.compactMap { $0 }
        }
        .replaceError(with: [])
        .eraseToAnyPublisher()
    
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
