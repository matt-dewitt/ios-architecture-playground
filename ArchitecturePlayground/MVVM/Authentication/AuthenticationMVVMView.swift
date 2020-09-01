//
//  AuthenticationMVVMView.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import SwiftUI

struct AuthenticationMVVMView<ViewModel: AuthenticationMVVMViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome")
                .font(.title)
            
            if viewModel.errorMessage != nil {
                Text(viewModel.errorMessage!)
                    .foregroundColor(.red)
            }
            
            TextField("Username", text: $viewModel.username)
                .padding(8)
                .border(Color.gray, width: 0.5)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            
            SecureField("Password", text: $viewModel.password)
                .padding(8)
                .border(Color.gray, width: 0.5)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            
            if !viewModel.isAuthenticating {
                Button(action: didTapLogin) {
                    Text("Log In")
                        .foregroundColor(.white)
                }
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
            } else {
                Text("Please wait...")
            }
        }
        .padding(20)
        .background(Color.white)
        .navigationTitle("Sign In")
    }
    
    private func didTapLogin() {
        viewModel.authenticate()
    }
}

struct AuthenticationMVVMView_Previews: PreviewProvider {
    private class PreviewViewModel: AuthenticationMVVMViewModelProtocol {
        var username: String
        var password: String
        var isAuthenticating: Bool
        var errorMessage: String?
        
        func authenticate() {}
        
        init(username: String, password: String, isAuthenticating: Bool, errorMessage: String?) {
            self.username = username
            self.password = password
            self.isAuthenticating = isAuthenticating
            self.errorMessage = errorMessage
        }
    }
    
    static var previews: some View {
        Group {
            AuthenticationMVVMView(
                viewModel: PreviewViewModel(
                    username: "",
                    password: "",
                    isAuthenticating: false,
                    errorMessage: nil
                )
            )
            
            AuthenticationMVVMView(
                viewModel: PreviewViewModel(
                    username: "testy",
                    password: "tester",
                    isAuthenticating: true,
                    errorMessage: "Something bad happened..."
                )
            )
        }
    }
}
