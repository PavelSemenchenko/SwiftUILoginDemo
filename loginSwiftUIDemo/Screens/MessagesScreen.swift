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
    @State var message: String = ""
    
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
                    HStack {
                        if item.sender == messagesVM.sender {
                            Spacer()
                            Text(item.text ?? "")
                                .padding(10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        } else {
                            Text(item.text ?? "")
                                .padding(10)
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: item.sender == messagesVM.sender ? .trailing : .leading)
                }
            }
            HStack {
                TextField("Type text", text: $message)
                Button("Send") {
                    Task {
                        await messagesVM.send(message)
                        message = ""
                    }
                }.disabled(message.isEmpty)
            }.padding()
        }
    }
}

class MessagesVM: ObservableObject {
    
    var sender: String {
        return Auth.auth().currentUser!.uid
        //        2qohzoWVk9an4k6vg9DhhTbRTP23
    }
    var recipient: String {
        return Auth.auth().currentUser!.uid != "3Xvd2rbVdbf1OXONG0ykK90QCD42" ?
        "3Xvd2rbVdbf1OXONG0ykK90QCD42" : "2qohzoWVk9an4k6vg9DhhTbRTP23"
    }
    
    lazy var items: AnyPublisher<[Message], Never> = {
        Firestore.firestore().collection("messages")
            .order(by: "created", descending: true)
            .whereFilter(Filter.andFilter([
                Filter.orFilter([
                    Filter.whereField("sender", isEqualTo: sender),
                    Filter.whereField("sender", isEqualTo: recipient),
                ]),
                Filter.orFilter([
                    Filter.whereField("recipient", isEqualTo: recipient),
                    Filter.whereField("recipient", isEqualTo: sender)
                ])
            ]))
        //.whereField("sender", isEqualTo: sender)
        //.whereField("recipient", isEqualTo: recipient)
            .snapshotPublisher()
            .map { $0.documents }
            .map { $0.map { doc in try? doc.data(as: Message.self)}}
            .map { $0.compactMap { c in c}}
            .map { $0.sorted { m1, m2 in
                m1.created < m2.created
            }}
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }()
    
    @MainActor func send(_ text: String) async {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let message = Message(sender: currentUserId,
                              recipient: recipient,
                              read: false,
                              text: text,
                              attachments: nil,
                              created: Date())
        let _ = Firestore.firestore().collection("messages").addDocument(from: message)
        /*
        let message1 = Message(sender: "3Xvd2rbVdbf1OXONG0ykK90QCD42",
                               recipient: currentUserId,
                               read: false,
                               text: "\(text) back",
                               attachments: nil,
                               created: Date())
        let _ = Firestore.firestore().collection("messages").addDocument(from: message1)
         */
    }
}

#Preview {
    MessagesScreen()
}
