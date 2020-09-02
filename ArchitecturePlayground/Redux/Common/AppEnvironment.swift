//
//  AppEnvironment.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation


protocol AppEnvironmentReduxProtocol {
    var services: AppEnvironmentServicesReduxProtocol { get set }
}

protocol AppEnvironmentServicesReduxProtocol {
    var authenticationApi: AuthenticationAPIProtocol { get set }
    var userSessionStore: UserSessionStoreProtocol { get set }
    var jobsApi: JobsAPIProtocol { get set }
}

struct AppEnvironmentRedux: AppEnvironmentReduxProtocol {
    var services: AppEnvironmentServicesReduxProtocol = MockAppServicesRedux()
    
}

struct MockAppServicesRedux: AppEnvironmentServicesReduxProtocol {
    var authenticationApi: AuthenticationAPIProtocol = MockAuthenticationAPI()
    var userSessionStore: UserSessionStoreProtocol = MockUserSessionStore()
    var jobsApi: JobsAPIProtocol = MockJobsAPI()
}
