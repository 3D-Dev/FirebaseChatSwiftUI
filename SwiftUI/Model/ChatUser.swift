//
//  ChatUser.swift
//  FirebaseChat
//
//  Created by pro on 3/17/22.
//

import Foundation

struct ChatUser: Identifiable {
    var id: String {uid}
    let uid, email, profileImageUrl: String
    
    init(data:[String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = (data["email"] as? String ?? "").replacingOccurrences(of: "@gmail.com", with: "")
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }
}
