//
//  LoginView.swift
//  ScrumdingerDemo
//
//  Created by Pixel Mission on 21.07.23.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewState: ViewStateHandler = ViewStateHandler()
    
    @State private var username = ""
    @State private var password = ""
    @State private var selectedDevice = "Device A"
    @State private var isLoginSuccessful = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Login to your Account")
                    .font(.title)

                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    viewState.login(username: username, password: password)
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                
            }
            .padding()
            
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewState: ViewStateHandler())
    }
}
