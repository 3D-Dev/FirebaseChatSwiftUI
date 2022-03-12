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
                VStack {
                    HStack(spacing: 16) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 36))
                        VStack(alignment: .leading) {
                            Text("UserName")
                                .font(.system(size: 24, weight: .bold))
                            Text("online")
                        }
                        Spacer()
                        Button {
                            
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 24))
                        }
                    }
                    Divider()
                }.padding(.horizontal)
                ScrollView {
                    ForEach(0..<10, id: \.self) {
                        num in
                        VStack {
                            HStack(spacing: 16) {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 36))
                                VStack(alignment: .leading) {
                                    Text("UserName")
                                    Text("Message sent to user")
                                }
                                Spacer()
                                Text("22h")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            Divider()
                        }.padding(.horizontal)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct MainMessageView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessageView()
    }
}
