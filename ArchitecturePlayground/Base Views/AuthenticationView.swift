//
//  AuthenticationView.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import SwiftUI

struct AuthenticationView: View {
    
    @Binding var username: String
    @Binding var password: String
    @State var isAuthenticating: Bool = false
    @State var errorMessage: String? = nil

    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome")
                .font(.title)
            
            if errorMessage != nil {
                Text(errorMessage!)
                    .foregroundColor(.red)
            }
            
            TextField("Username", text: $username)
                .padding(8)
                .border(Color.gray, width: 0.5)
            
            SecureField("Password", text: $password)
                .padding(8)
                .border(Color.gray, width: 0.5)
            
            if !isAuthenticating {
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
    }
    
    private func didTapLogin() {
        
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AuthenticationView(
                username: .constant(""),
                password: .constant(""),
                isAuthenticating: false,
                errorMessage: nil
            )
            
            AuthenticationView(
                username: .constant("testy"),
                password: .constant("tester"),
                isAuthenticating: true,
                errorMessage: "Something bad happened..."
            )
        }
    }
}
