//
//  MainMessageView.swift
//  FirebaseChat
//
//  Created by pro on 2022-03-11.
//

import SwiftUI

struct MainMessageView: View {
    var body: some View {
        NavigationView {
            VStack {
                    HStack(spacing: 16) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 36))
                        VStack(alignment: .leading, spacing: 4) {
                            Text("UserName")
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

                        } label: {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 24))
                        }
                    }.padding()
                    //Divider()
                ScrollView {
                    ForEach(0..<10, id: \.self) {
                        num in
                        VStack {
                            HStack(spacing: 16) {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 32))
                                    .padding()
                                    .overlay(RoundedRectangle(cornerRadius: 44)
                                                .stroke(lineWidth: 1))
                                VStack(alignment: .leading) {
                                    Text("UserName")
                                    Text("Message sent to user")
                                }
                                Spacer()
                                Text("22h")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            Divider()
                                .padding(.vertical, 8)
                        }.padding(.horizontal)
                    }
                }
                Button {
                    
                } label: {
                    HStack {
                        Spacer()
                        Text("+ New Message")
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .background(Color.blue)
                    .cornerRadius(32)
                    .padding(.horizontal, 15)
                }
            }.navigationBarHidden(true)
        }
    }
}

struct MainMessageView_Previews: PreviewProvider {
    static var previews: some View {
            MainMessageView()

    }
}
