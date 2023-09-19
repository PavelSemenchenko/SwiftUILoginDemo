//
//  BaseListVM.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 19.09.2023.
//

import Foundation
import FirebaseAuth

class BaseListVM<E> : ObservableObject where E: Hashable {
    @Published var items: [E] = nil
    @Published var emptyText: String? = nil
    @Published var errorText: String? = nil
    
    @MainActor func load() async {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            errorText = "You need to be authenticated"
            return
        }
        do { let data =  try await loadData(userId: currentUserId)
            if data.isEmpty {
                emptyText = "No items"
            } else {
                items = data
            }
        } catch {
            errorText = error.localizedDescription
            items = nil
            emptyText = nil
        }
    }
    
    @MainActor func loadMore() async {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            errorText = "You need to be authenticated"
            return
        }
    }
    
    func loadData(userId: String) async throws -> [E] {
        fatalError("Must be ovverriden in subclass")
    }
}
