//
//  MainMessageView.swift
//  FirebaseChat
//
//  Created by pro on 2022-03-11.
//

import SwiftUI

struct MainMessageView: View {
    @State var shouldShowLogOutOptions = false
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
                            shouldShowLogOutOptions.toggle()
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 24))
                                .foregroundColor(Color(.label))
                        }
                    }.padding()
                    .actionSheet(isPresented: $shouldShowLogOutOptions) {
                        .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [.destructive(Text("Sign Out"), action: {print("handle sign out")}),.cancel()])
                    }                    //Divider()
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
                    }.padding(.bottom, 50)
                }
            }
            .overlay(
                Button {
                    
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
                }, alignment: .bottom)
        .navigationBarHidden(true)
        }
    }
}

struct MainMessageView_Previews: PreviewProvider {
    static var previews: some View {
            MainMessageView()
            .preferredColorScheme(.dark)

    }
}
