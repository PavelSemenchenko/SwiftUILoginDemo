//
//  ConversationsScreen.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 08.10.2023.
// 31.55

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift

struct ConversationsScreen: View {

    @ObservedObject var conversationsVM: ConversationsVM = ConversationsVM()

    var body: some View {
        VStack {
            Text("Conversations")
                    .font(.headline)
                    .padding(5)
            EndlessList(vm: ConversationsVM) { (item: ConversationItem) in
                CommonUserItem(item: item.user)
            }
        }
    }
}
// model for visualisation
struct ConversationItem: Hashable, Identifiable {
    var id: String? {
        get {
            message.id
        }
    }
    let user: Contact
    let message: Message
}

class ConversationsVM: BaseListVM<ConversationItem> {
    
    @Published var items: [ConversationItem]? = nil
    @Published var emptyText: String? = nil
    @Published var errorText: String? = nil
    
   
    func loadData(userId: String) async throws -> [ConversationItem] {

        let snapshot = try? await
        Firestore.firestore()
                .collection("people")
                .document(userId)
                .collection("conversations")
                .getDocuments()

        let conversations = snapshot?.documents.map { try? $0.data(as: Conversation.self)}.compactMap { $0 }

        guard let conversations = conversations, !conversations.isEmpty else {
            return []
        }

        let opponents = conversations.map { $0.oponent }.compactMap { $0 }

        let snapshot2 = try? await
        Firestore.firestore()
                .collection("people")
                .whereField("userId", in: opponents).getDocuments()

        let users = snapshot2?.documents.map { doc in
                    try! doc.data(as: Contact.self)
                }.compactMap { $0 }

        let msgs = conversations.map { $0.messageId }

        var messages: [Message] = []
        for message in msgs {
            let snapshot3 = try? await
            Firestore.firestore().collection("messages").document(message).getDocument()
            if let m = try? snapshot3?.data(as: Message.self) {
                messages.append(m)
            }
        }
        // выше получили массив пользователей и сообщений. далее собираем их вместе
        let items: [ConversationItem?] = conversations.map { c in
            let message = messages.first { m in
                m.id == c.messageId
            }
            let user = users?.first { u in
                u.id == c.oponent
            }
            guard let user = user, let message = message else {
                return nil
            }
            return ConversationItem(user: user, message: message)
        }
        return items.compactMap { $0 }



    }
}

#Preview {
    ConversationsScreen()
}
