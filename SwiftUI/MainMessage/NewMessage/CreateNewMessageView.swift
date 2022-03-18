//
//  CreateNewMessageView.swift
//  FirebaseChat
//
//  Created by pro on 3/17/22.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

class CreateNewMessageViewModel: ObservableObject {
    @Published var users = [ChatUser]()
    @Published var errorMessage = ""
    
    init() {
        fetchAllUsers()
    }
    
    private func fetchAllUsers() {
        FirebaseManager.shared.firestore.collection("users").getDocuments { documentsSnapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch users\(error)"
                print("Failed to fetch users:\(error)")
                return
            }
            documentsSnapshot?.documents.forEach({ snapshot in
                let data = snapshot.data()
                let user = ChatUser(data: data)
                if user.uid !=
                    FirebaseManager.shared.auth.currentUser?.uid{
                        self.users.append(.init(data: data))
                }
            })
        }
    }
}
struct CreateNewMessageView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm = CreateNewMessageViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(vm.users) { user in
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack(spacing: 16) {
                            WebImage(url: URL(string: user.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                                .overlay(RoundedRectangle(cornerRadius: 50)
                                            .stroke(Color(.label),
                                                   lineWidth: 1))
                            Text(user.email)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    Divider()
                        .padding(.vertical, 5)
                }
            }.navigationTitle("New Message")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Back")
                        }
                    }
                }
        }
    }
}

struct CreateNewMessageView_Preview: PreviewProvider {
    static var previews: some View {
        MainMessageView()
    }
}

