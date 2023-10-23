//
//  BaseListVM.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 19.09.2023.
//

import Foundation
import FirebaseAuth

protocol BaseListVM: ObservableObject {
    associatedtype E : Hashable , Identifiable
    
    var items: [E]? { get set }
    var emptyText: String? { get set }
    var errorText: String? { get set }
    
        
    func loadData(userId: String) async throws -> [E] 
}

extension BaseListVM {
    func load() async {
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
    
    func loadMore() async {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            errorText = "You need to be authenticated"
            return
        }
    }
}
