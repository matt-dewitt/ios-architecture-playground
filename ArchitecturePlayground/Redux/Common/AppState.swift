//
//  AppState.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation

struct AppState {
    var authentication: AuthenticationState
    var jobs: JobsState
}

struct AuthenticationState: Equatable {
    static func == (lhs: AuthenticationState, rhs: AuthenticationState) -> Bool {
        return true
    }
    
    var userSession: UserSession? = nil
    var isAuthenticating: Bool = false
    var errorMessage: String? = nil
}

struct JobsState {
    
}
