//
//  AppState.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation

struct AppStateRedux: Equatable {
    var authentication: AuthenticationStateRedux
    var jobs: JobsStateRedux
}

struct AuthenticationStateRedux: Equatable {

    var userSession: UserSession? = nil
    var isAuthenticating: Bool = false
    var errorMessage: String? = nil
}

struct JobsStateRedux: Equatable {
    var jobs: [Job] = []
    var isLoadingJobs: Bool = false
    var errorMessage: String? = nil
    var selectedJobDetails: Job? = nil
}
