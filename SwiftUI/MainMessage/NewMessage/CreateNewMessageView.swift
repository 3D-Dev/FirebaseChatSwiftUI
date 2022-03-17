//
//  CreateNewMessageView.swift
//  FirebaseChat
//
//  Created by pro on 3/17/22.
//

import Foundation
import SwiftUI

struct CreateNewMessageView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(0..<10) { num in
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

