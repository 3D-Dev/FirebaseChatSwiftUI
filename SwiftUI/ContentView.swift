//
//  ContentView.swift
//  SwiftUI
//
//  Created by pro on 2022-03-10.
//

import SwiftUI

struct ContentView: View {
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""

    var body: some View {
        NavigationView {
            ScrollView {
                
                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    if isLoginMode {
                        Button {
                            
                        } label: {
                            Image(systemName: "person.crop.circle.fill.badge.plus")
                                .font(.system(size: 64))
                                .padding()
                        }
                    }
                    
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    SecureField("Password", text: $password)
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Spacer()
                            Text("Create Account")
                                .font(.system(size: 21))
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                           Spacer()
                        }.background(.blue)
                            
                    }
                }.padding()
                
                Text("Here is my creation account page")
            }.navigationTitle(isLoginMode ? "Login" : "Create Account")
    
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
