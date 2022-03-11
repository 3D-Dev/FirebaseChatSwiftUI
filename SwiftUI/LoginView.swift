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
                        handleAction()
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
                    Text(self.loginStatusMessage)
                        .foregroundColor(.red)
                }
                .padding()
            }
            .navigationTitle(isLoginMode ? "Login" : "Create Account")
            .background(Color(.init(white: 0, alpha: 0.05 )))
        }
    }
    
    private func handleAction() {
        if isLoginMode {
            loginAccount()
        } else {
            createNewAccount()
        }
    }
    
    @State var loginStatusMessage = ""
    private func createNewAccount() {
        Auth.auth().createUser(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("Failed to create user:", err)
                self.loginStatusMessage = "Failed to create user: \(err)"
                return
            }
            print("Successfully create user: \(result?.user.uid ?? "")")
            self.loginStatusMessage = "Successfully create user: \(result?.user.uid ?? "")"
        }
    }
    
    private func loginAccount() {
        Auth.auth().signIn(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("Failed to login user:", err)
                self.loginStatusMessage = "Failed to login user: \(err)"
                return
            }
            print("Successfully login user: \(result?.user.uid ?? "")")
            self.loginStatusMessage = "Successfully login user: \(result?.user.uid ?? "")"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
