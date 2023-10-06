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
/*
struct Contact: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
   // @ServerTimestamp var created: Date?
    let name: String
}
 */

struct Contact: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    let name: String
    var status: FollowStatus = .none
    
    enum CodingKeys: CodingKey {
        case id
        case name
    }
}

struct Attachment: Codable,Hashable {
    let type: String
    let contentURL: String
}

struct Message: Codable, Identifiable,Hashable {
    @DocumentID var id: String?
    
    let sender: String
    let recipient: String
    
    var read: Bool
    let text: String?
    let attachments: [Attachment]?
    
    let created: Date
    @ServerTimestamp var delivered: Date?
}

