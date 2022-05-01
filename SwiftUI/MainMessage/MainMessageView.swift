//
//  MainMessageView.swift
//  FirebaseChat
//
//  Created by pro on 2022-03-11.
//

import SwiftUI
import FirebaseFirestoreSwift
import SDWebImageSwiftUI
import Firebase

struct RecentMessage: Identifiable {

    var id: String { documentId }

    let documentId: String
    let text, email: String
    let fromId, toId: String
    let profileImageUrl: String
    let timestamp: Timestamp

    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.text = data[FirebaseConstants.text] as? String ?? ""
        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
        self.toId = data[FirebaseConstants.toId] as? String ?? ""
        self.profileImageUrl = data[FirebaseConstants.profileImageUrl] as? String ?? ""
        self.email = data[FirebaseConstants.email] as? String ?? ""
        self.timestamp = data[FirebaseConstants.timestamp] as? Timestamp ?? Timestamp(date: Date())
    }
}

class MainMessagesViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    //Second method for access to firestore
    //@Published var chatUser = [ChatUser]()
    //@Published var userData : ChatUser?
    @Published var chatUser : ChatUser?
    @Published var isUserCurrentlyLoggedOut = false

    init() {
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        fetchCurrentUser()
        fetchRecentMessage()
    }
    @Published var recentMessages = [RecentMessage]()
    
    private func fetchRecentMessage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }

        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener{querySnapshot, error in
                 if let error = error {
                self.errorMessage = "Failed to lesten for recent message:\(error)"
                print(error)
                return
                }
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.documentId == docId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    self.recentMessages.insert(.init(documentId: docId, data: change.document.data()), at: 0)
                })
            }
    }
    func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return

        }
        self.errorMessage = "\(uid)"
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
                    if let error = error {
                        self.errorMessage = "Failed to fetch current user: \(error)"
                        print("Failed to fetch current user:", error)
                        return
                    }

                    guard let data = snapshot?.data() else {
                        self.errorMessage = "No data found"
                        return

                    }
            self.chatUser = .init(data: data)
            
        }
        
// Second method for access to firestore
//        FirebaseManager.shared.firestore.collection("users").addSnapshotListener {(querySnapshot, error) in
//            guard let documents = querySnapshot?.documents else {
//                print("No documents")
//                return
//            }
//            self.chatUser = documents.map {
//                queryDocumentSnapshot -> ChatUser in
//                let data = queryDocumentSnapshot.data()
//                let uid = data["uid"] as? String ?? ""
//                let email = data["email"] as? String ?? ""
//                let profileImageUrl = data["profileImageUrl"] as? String ?? ""
//                let chatUser = ChatUser(uid: uid, email: email, profileImageUrl: profileImageUrl)
//                self.userData = chatUser
//                self.errorMessage = chatUser.profileImageUrl
//                print(chatUser.profileImageUrl)
//                return chatUser
//            }
//        }
    }
    
    func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
        self.errorMessage = "LoginStatus'\(isUserCurrentlyLoggedOut)'"
        print("LoginStatus'\(isUserCurrentlyLoggedOut)'")
        try?FirebaseManager.shared.auth.signOut()
    }
}
struct MainMessageView: View {
    
    @State var shouldNaviateToChatLogView = false
    @State var shouldShowLogOutOptions = false
    @ObservedObject private var vm = MainMessagesViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text(vm.errorMessage)
                    .foregroundColor(.red)
                customNavBar
                messageView
                NavigationLink("LogView", isActive: $shouldNaviateToChatLogView) {
                    ChatLogView(chatUser: self.chatUser)
                }
            }
            .overlay(
                newMessageButton, alignment: .bottom)
        .navigationBarHidden(true)
        }
    }
    
    private var customNavBar: some View {
        HStack(spacing: 16) {
            WebImage(url: URL(string: vm.chatUser?.profileImageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 49, height: 49)
                .clipped()
                .cornerRadius(49)
                .overlay(RoundedRectangle(cornerRadius: 44)
                            .stroke(lineWidth: 1))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(vm.chatUser?.email ?? "")
                    .font(.system(size: 24, weight: .bold))
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }
            }
            Spacer()
            Button {
                shouldShowLogOutOptions.toggle()
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color(.label))
            }
        }.padding()
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            .init(title: Text("Settings"), message: Text("What do you want to do?"),
                  buttons: [.destructive(Text("Sign Out"),
                                         action: {print("handle sign out");vm.handleSignOut()}),.cancel()])
        }
        .fullScreenCover(isPresented: $vm.isUserCurrentlyLoggedOut, onDismiss: nil) {
            LoginView(didCompleteLoginProcess: {
                self.vm.isUserCurrentlyLoggedOut = false
                self.vm.fetchCurrentUser()
            })
        }

    }
    
    private var messageView : some View {
        ScrollView {
            ForEach(vm.recentMessages) {
                recentMessage in
                    VStack {
                        NavigationLink{
                            Text("Destination")
                        } label: {
                            HStack(spacing: 16) {
                                WebImage(url: URL(string: recentMessage.profileImageUrl))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 64, height: 64)
                                    .clipped()
                                    .cornerRadius(64)
                                    .overlay(RoundedRectangle(cornerRadius: 64)
                                                .stroke(Color.black, lineWidth: 1))
                                    .shadow(radius: 5)
                                
                                VStack(alignment: .leading) {
                                    Text(recentMessage.email)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(Color(.label))
                                    Text(recentMessage.text)
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(.lightGray))
                                }
                                Spacer()
                                Text("22h")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            Divider()
                                .padding(.vertical, 8)
                        }
                    }
                }.padding(.horizontal)
        }.padding(.bottom, 50)
    }
    
    @State var shouldShowNewMessageScreen = true
    @State var chatUser: ChatUser?
    private var newMessageButton : some View {
            Button {
                shouldShowNewMessageScreen.toggle()
            } label: {
                HStack {
                    Spacer()
                    Text("+ New Message")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.vertical)
                .background(Color.blue)
                .cornerRadius(32)
                .padding(.horizontal, 15)
                .shadow(radius: 15)
            }
            .fullScreenCover(isPresented: $shouldShowNewMessageScreen, onDismiss: nil) {
                CreateNewMessageView(didSelectNewUser: {
                    user in
                    print(user.email)
                    self.shouldNaviateToChatLogView.toggle()
                    self.chatUser = user
                })
            }
    }
}

struct MainMessageView_Previews: PreviewProvider {
    static var previews: some View {
            //MainMessageView()
            //.preferredColorScheme(.dark)
            MainMessageView()

    }
}
