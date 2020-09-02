//
//  AppActions.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation

enum AppActionRedux: Equatable {
    case authentication(action: AuthenticationActionRedux)
    case jobs(action: JobsActionRedux)
}

enum AuthenticationActionRedux: Equatable {
    case authenticate(username: String, password: String)
    case saveUserSession(session: UserSession)
    case authenticationSucceeded(session: UserSession)
    case authenticationFailed(errorMessage: String)
}

enum JobsActionRedux: Equatable {
    case loadJobs
    case reloadJobs
    case jobsLoaded(jobs: [Job])
    case failedToLoadJobs(errorMessage: String)
}
