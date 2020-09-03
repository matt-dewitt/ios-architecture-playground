//
//  AuthenticationCAView.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/2/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct AuthenticationCAView: View {
    let store: Store<AuthenticationStateCA, AuthenticationActionCA>
    
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 16) {
                Text("Welcome")
                    .font(.title)
                
                if let error = viewStore.state.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }
                
                TextField("Username", text: $username)
                    .padding(8)
                    .border(Color.gray, width: 0.5)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .padding(8)
                    .border(Color.gray, width: 0.5)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                
                if !viewStore.state.isAuthenticating {
                    Button(action: {
                        viewStore.send(.authenticate(username: username, password: password))
                    }) {
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
    }
    
}

struct AuthenticationCAView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationCAView(
            store: Store(
                initialState: AuthenticationStateCA(
                    userSession: nil,
                    isAuthenticating: false,
                    errorMessage: nil
                ),
                reducer: authenticationReducer,
                environment: AppEnvironmentCA(
                    authenticationApi: MockAuthenticationAPI(),
                    userSessionStore: MockUserSessionStore(),
                    jobsApi: MockJobsAPI(),
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                )
            )
        )
    }
}
