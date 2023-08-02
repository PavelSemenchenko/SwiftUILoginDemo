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
    case loaded
    case failed
}

struct Contact: Codable, Identifiable,Hashable {
    @DocumentID var id: String?
    @ServerTimestamp var created: Date?
    let name: String
}

