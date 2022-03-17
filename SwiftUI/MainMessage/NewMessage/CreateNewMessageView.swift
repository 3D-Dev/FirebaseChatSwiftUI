//
//  CreateNewMessageView.swift
//  FirebaseChat
//
//  Created by pro on 3/17/22.
//

import Foundation
import SwiftUI

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
                self.users.append(.init(data: data))
            })
        }
    }
}
struct CreateNewMessageView: View {
    @ObservedObject var vm = CreateNewMessageViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(vm.users) { num in
                    Text("New User")
                }
            }.navigationTitle("New Message")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            
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
        CreateNewMessageView()
    }
}

