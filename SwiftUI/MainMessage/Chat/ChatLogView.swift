//
//  ChatLogView.swift
//  FirebaseChat
//
//  Created by pro on 3/22/22.
//

import SwiftUI

struct ChatLogView : View {
    let chatUser:ChatUser?
    @State var chatText = ""
    
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
    
    private var messageView: some View {
        ScrollView {
            ForEach(0..<10) { num in
                HStack {
                    Spacer()
                    HStack {
                        Text("Fake Message")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            HStack{Spacer() }
        }
        .background(Color(.init(white: 0.9, alpha: 1)))
    }
    
    private var chatBottomBar: some View {
        HStack() {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 28))
                .foregroundColor(Color(.darkGray))
            //TextEditor(text: $chatText)
            TextField("Description", text: $chatText)
            Button {
                
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

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                ChatLogView(chatUser: .init(data: ["uid": "", "email": "test@gmail.com"]))
            }
            NavigationView {
                ChatLogView(chatUser: .init(data: ["uid": "", "email": "test@gmail.com"]))
            }
            NavigationView {
                ChatLogView(chatUser: .init(data: ["uid": "", "email": "test@gmail.com"]))
            }
            NavigationView {
                ChatLogView(chatUser: .init(data: ["uid": "", "email": "test@gmail.com"]))
            }
.previewInterfaceOrientation(.landscapeLeft)
        }
    }
}