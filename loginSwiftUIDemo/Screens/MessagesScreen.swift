//
//  MessagesScreen.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 28.09.2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift

struct MessagesScreen: View {
    @ObservedObject var messagesVM: MessagesVM = MessagesVM()
    
    var body: some View {
        VStack {
            Text("Messages")
            Button("Send") {
                Task {
                    await messagesVM.send
                }
            }
        }
    }
}

class MessagesVM: ObservableObject {
    
    @MainActor func send() async {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            fatalError("need authentication")
        }
        
        let message = Message(sender: currentUserId,
                              recipient: "NqK3JBgfLPUcsy6CtS6bu0sPdjA2",
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
