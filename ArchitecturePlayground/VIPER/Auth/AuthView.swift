//
//  AuthView.swift
//  ArchitecturePlayground
//
//  Created by Andrew Strauss on 9/3/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import SwiftUI

class AuthViewModel: ObservableObject, AuthViewInput {
    @Published var username: String
    @Published var password: String

    @Published var isAuthenticating: Bool
    @Published var errorMessage: String?

    init(username: String = "", password: String = "", isAuthenticating: Bool = false, errorMessage: String? = nil) {
        self.username = username
        self.password = password
        self.isAuthenticating = isAuthenticating
        self.errorMessage = errorMessage
    }
}

struct AuthVIPERView: View, ViewProtocol {
    @ObservedObject var viewModel: AuthViewModel
    var presenter: AuthViewResponder

    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome")

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            TextField("Username", text: $viewModel.username)
                .autocapitalization(.none)

            SecureField("Password", text: $viewModel.password)

            if !viewModel.isAuthenticating {
                Button(action: didTapLogin) {
                    Text("Log In")
                }
            } else {
                Text("Logging in, please wait...")
            }
        }
        .padding(20)
    }

    private func didTapLogin() {
        presenter.handleLogin()
    }
}

struct AuthView_Previews: PreviewProvider {
    private class PreviewResponder: AuthViewResponder {
        func handleLogin() {}
    }

    static var previews: some View {
        Group {
            AuthVIPERView(viewModel: AuthViewModel(), presenter: PreviewResponder())

            AuthVIPERView(
                viewModel: AuthViewModel(
                    username: "bob",
                    password: "password",
                    isAuthenticating: true,
                    errorMessage: "Something bad happened..."
                ),
                presenter: PreviewResponder()
            )
        }
    }
}
