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
                /*
                List(items) { item in
                    if (item.sender == messagesVM.sender) {
                        HStack {
                            Spacer()
                            Text(item.text ?? "")
                                
                        }.frame(maxWidth: .infinity,
                                alignment: .leading)
                    } else {
                        HStack {
                            Text(item.text ?? "")
                        }.frame(maxWidth: .infinity,
                                alignment: .leading)
                    }
                }*/
            }
            Button("Send") {
                Task {
                    await messagesVM.send()
                }
            }.padding()
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
            //.whereField("sender", isEqualTo: sender)
            //.whereField("recipient", isEqualTo: recipient)
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
                              recipient: "3Xvd2rbVdbf1OXONG0ykK90QCD42",
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
