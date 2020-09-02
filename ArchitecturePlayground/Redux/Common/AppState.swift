//
//  AppState.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation

struct AppState: Equatable {
    var authentication: AuthenticationState
    var jobs: JobsState
}

struct AuthenticationState: Equatable {

    var userSession: UserSession? = nil
    var isAuthenticating: Bool = false
    var errorMessage: String? = nil
}

struct JobsState: Equatable {
    var jobs: [Job] = []
    var isLoadingJobs: Bool = false
    var errorMessage: String? = nil
    var selectedJobDetails: Job? = nil
}
