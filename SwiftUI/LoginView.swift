//
//  ContentView.swift
//  SwiftUI
//
//  Created by pro on 2022-03-10.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""

    init() {
        FirebaseApp.configure()
    }
    
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
                    
                    if !isLoginMode {
                        Button {
                            
                        } label: {
                            Image(systemName: "person.crop.circle.fill.badge.plus")
                                .font(.system(size: 64))
                                .padding()
                        }
                    }
                    
                    Group {
                        HStack {
                            Image(systemName: "envelope")
                                                .foregroundColor(.gray).font(.headline)
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        HStack {
                            Image(systemName: "lock.fill")
                                                .foregroundColor(.gray).font(.headline)
                            SecureField("Password", text: $password)
                        }
                        
                    }
                    .padding(12)
                    .background(.white)
                    
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Login" : "Create Account")
                                .font(.system(size: 21))
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                           Spacer()
                        }.background(.blue)
                            
                    }
                }
                .padding()
            }
            .navigationTitle(isLoginMode ? "Login" : "Create Account")
            .background(Color(.init(white: 0, alpha: 0.05 )))
        }
    }
    
    private func handleAction() {
        if isLoginMode {
            
        } else {
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
