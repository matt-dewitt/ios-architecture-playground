//
//  AuthenticationReduxView.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import SwiftUI

struct AuthenticationReduxView: View {
    @EnvironmentObject var store: StoreRedux<AppStateRedux, AppActionRedux, AppEnvironmentReduxProtocol>
    
    @State var username: String = ""
    @State var password: String = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome")
                .font(.title)
            
            if let error = store.state.authentication.errorMessage {
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
            
            if !store.state.authentication.isAuthenticating {
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
        store.send(.authentication(action:.authenticate(username: username, password: password)))
    }
}

struct AuthenticationReduxView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationReduxView()
    }
}
