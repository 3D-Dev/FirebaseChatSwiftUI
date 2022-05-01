//
//  ChatLogView.swift
//  FirebaseChat
//
//  Created by pro on 3/22/22.
//

import SwiftUI
import Firebase

struct FirebaseConstants {
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"
    static let timestamp = "timestamp"
    static let profileImageUrl = "profileImageUrl"
    static let email = "email"
}

struct ChatMessage: Identifiable {

    var id: String { documentId }

    let documentId: String
    let fromId, toId, text: String

    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
        self.toId = data[FirebaseConstants.toId] as? String ?? ""
        self.text = data[FirebaseConstants.text] as? String ?? ""
    }
}

class ChatLogViewModel : ObservableObject {
    @Published var chatText = ""
    @Published var errorMessage = ""
    @Published var chatMessages = [ChatMessage]()

    let chatUser: ChatUser?
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        fetchMessages()
    }
    
    private func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        guard let toId = chatUser?.uid else {return}
        FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .addSnapshotListener{querySnapshot, error in
                 if let error = error {
                    self.errorMessage = "Failed to lesten for messages:\(error)"
                    print(error)
                    return
                }
                querySnapshot?.documentChanges.forEach({change in
                    if change.type == .added {
                        let data = change.document.data()
                        self.chatMessages.append(.init(documentId: change.document.documentID, data: data))
                    }
                })
                DispatchQueue.main.async {
                    self.count += 1
                }
            }
    }
    
    private func persistRecentMessage() {
        guard let chatUser = chatUser else { return }

        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = self.chatUser?.uid else { return }

        let document = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .document(toId)

        let data = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.profileImageUrl: chatUser.profileImageUrl,
            FirebaseConstants.email: chatUser.email
        ] as [String : Any]

        // you'll need to save another very similar dictionary for the recipient of this message...how?

        document.setData(data) { error in
            if let error = error {
                self.errorMessage = "Failed to save recent message: \(error)"
                print("Failed to save recent message: \(error)")
                return
            }
        }

//        guard let currentUser = FirebaseManager.shared.currentUser else { return }
//        let recipientRecentMessageDictionary = [
//            FirebaseConstants.timestamp: Timestamp(),
//            FirebaseConstants.text: self.chatText,
//            FirebaseConstants.fromId: uid,
//            FirebaseConstants.toId: toId,
//            FirebaseConstants.profileImageUrl: currentUser.profileImageUrl,
//            FirebaseConstants.email: currentUser.email
//        ] as [String : Any]
//
//        FirebaseManager.shared.firestore
//            .collection("recent_messages")
//            .document(toId)
//            .collection("messages")
//            .document(currentUser.uid)
//            .setData(recipientRecentMessageDictionary) { error in
//                if let error = error {
//                    print("Failed to save recipient recent message: \(error)")
//                    return
//                }
//            }
    }
    
    func handleSend() {
        print(chatText)
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        guard let toId = chatUser?.uid else {return}
        let document = FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
        let messageData = ["fromId":fromId, "toId":toId, "text":chatText, "timestamp":Timestamp()] as [String:Any]
        document.setData(messageData) {error in
            if let error = error {
                self.errorMessage = "Fail to save message into Firestore:\(error)"
                return
            }
            print("Successfully saved current user sending in tht morning")
            self.chatText = ""
            self.count += 1
        }
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages")
                    .document(toId)
                    .collection(fromId)
                    .document()

        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }

            print("Recipient saved message as well")
        }
    }
    @Published var count = 0
}
struct ChatLogView : View {
    let chatUser:ChatUser?
    @ObservedObject var vm: ChatLogViewModel
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        self.vm = .init(chatUser: chatUser)
    }
    
    var body: some View {
        ZStack {
            messageView
            VStack {
                Spacer()
                chatBottomBar
                    .background(Color.white)
            }
        }
        .navigationTitle(chatUser?.email ?? "ssss")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    static var emptyScrollToString = "Empty"
    private var messageView: some View {
        ScrollView {
            ScrollViewReader { scrollViewProxy in
                VStack {
                        ForEach(vm.chatMessages) { message in
                                MessageView(message: message)
                            }
                        HStack{ Spacer() }
                        .id(Self.emptyScrollToString)
                    }
                .onReceive(vm.$count) { _ in
                    withAnimation(.easeOut(duration: 0.5)) {
                        scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                    }
                }
            }
        }
        .background(Color(.init(white: 0.9, alpha: 1)))
        .safeAreaInset(edge: .bottom) {
            chatBottomBar
                .background(Color(.systemBackground)
                                .ignoresSafeArea())
        }
    }
    
    private var chatBottomBar: some View {
        HStack() {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 28))
                .foregroundColor(Color(.darkGray))
            
            ZStack {
                TextEditor(text: $vm.chatText)
                    .opacity(vm.chatText.isEmpty ? 0.5 : 1)
            }
            .frame(height: 40)
            //TextEditor(text: $chatText)
            //TextField("Description", text: $vm.chatText)
            Button {
                vm.handleSend()
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.blue)
            .cornerRadius(4)

        }
        .padding()
    }
        
}

struct MessageView: View {
    let message: ChatMessage
    var body: some View {
        VStack {
            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                HStack {
                    Spacer()
                    HStack {
                        Text(message.text)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
            }
            else {
                HStack {
                    Spacer()
                    HStack {
                        Text(message.text)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                ChatLogView(chatUser: .init(data: ["uid": "", "email": "test@gmail.com"]))
            }
        }
    }
}
