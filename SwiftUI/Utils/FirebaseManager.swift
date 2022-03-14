//
//  FirebaseManager.swift
//  FirebaseChat
//
//  Created by pro on 2022-03-14.
//

import Foundation
import Firebase

class FirebaseManager: NSObject {
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    static let shared = FirebaseManager()
    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        super.init()
    }
}
