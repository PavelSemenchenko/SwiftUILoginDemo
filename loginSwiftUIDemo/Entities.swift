//
//  Entities.swift
//  loginSwiftUIDemo
//
//  Created by mac on 02.08.2023.
//

import SwiftUI
import FirebaseFirestoreSwift

enum EntityStastus {
    case initial
    case loading
    case moreLoading
    case loaded
    case failed
    case empty
    case searching
}

enum FollowStatus {
    case followed
    case pending
    case none
}

struct Contact: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
   // @ServerTimestamp var created: Date?
    let name: String
}

struct SocialContact: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    let name: String
    var status: FollowStatus = .none
    
    enum CodingKeys: CodingKey {
        case id
        case name
    }
}

