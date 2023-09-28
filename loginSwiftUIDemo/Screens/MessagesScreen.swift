//
//  MessagesScreen.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 28.09.2023.
//

import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift

struct MessagesScreen: View {
    @StateObject var messagesVM: MessagesVM = MessagesVM()
    @State var items: [Message] = []
    
    var body: some View {
        VStack {
            Text("Messages")
                .onReceive(messagesVM.items) {
                    items = $0
                }
            if (items.isEmpty) {
                Text("No messages")
            } else {
                List(items) { item in
                    if (item.sender == messagesVM.sender) {
                        VStack(alignment: .trailing) {
                            Text( item.text ?? "")
                        }
                    } else {
                        VStack(aligment: .leading) {
                            Text(item.text ?? "")
                        }
                    }
                }
            }
            Button("Send") {
                Task {
                    await messagesVM.send()
                }
            }
        }
    }
}

class MessagesVM: ObservableObject {
    
    var sender: String {
        return Auth.auth().currentUser!.uid
    }
    var recipient: String {
        return "3Xvd2rbVdbf1OXONG0ykK90QCD42"
    }
    
    lazy var items: AnyPublisher<[Message], Never> = {
        Firestore.firestore().collection("messages")
            .order(by: "created", descending: true)
            .whereField("sender", isEqualTo: sender)
            .whereField("recipient", isEqualTo: recipient)
            .snapshotPublisher()
            .map { $0.documents }
            .map { $0.map { doc in try? doc.data(as: Message.self)}}
            .map { $0.compactMap { c in c}}
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }()
    
    @MainActor func send() async {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let message = Message(sender: currentUserId,
                              recipient: recipient,
                              read: false,
                              text: "Hello",
                              attachments: nil,
                              created: Date())
        let _ = Firestore.firestore().collection("messages").addDocument(from: message)
    }
}

#Preview {
    MessagesScreen()
}
