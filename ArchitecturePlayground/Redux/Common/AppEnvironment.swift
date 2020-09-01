//
//  AppEnvironment.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation


protocol AppEnvironmentProtocol {
    var services: AppEnvironmentServicesProtocol { get set }
}

protocol AppEnvironmentServicesProtocol {
    var authenticationApi: AuthenticationAPIProtocol { get set }
    var userSessionStore: UserSessionStoreProtocol { get set }
    var jobsApi: JobsAPIProtocol { get set }
}

struct AppEnvironment: AppEnvironmentProtocol {
    var services: AppEnvironmentServicesProtocol = MockAppServices()
    
}

struct MockAppServices: AppEnvironmentServicesProtocol {
    var authenticationApi: AuthenticationAPIProtocol = MockAuthenticationAPI()
    var userSessionStore: UserSessionStoreProtocol = MockUserSessionStore()
    var jobsApi: JobsAPIProtocol = MockJobsAPI()
}
