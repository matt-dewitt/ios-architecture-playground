//
//  AppActions.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation

enum AppAction: Equatable {
    case authentication(action: AuthenticationAction)
    case jobs(action: JobsAction)
}

enum AuthenticationAction: Equatable {
    static func == (lhs: AuthenticationAction, rhs: AuthenticationAction) -> Bool {
        return true
    }
    
    case authenticate(username: String, password: String)
    case saveUserSession(session: UserSession)
    case authenticationSucceeded(session: UserSession)
    case authenticationFailed(errorMessage: String)
}

enum JobsAction: Equatable {
    case loadJobs
    case reloadJobs
    case jobsLoaded(jobs: [Job])
    case failedToLoadJobs(errorMessage: String)
    case viewJobDetails(job: Job)
}
