//
//  AppCore.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/2/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Combine

// MARK: - State
struct AppStateCA: Equatable {
    var authentication: AuthenticationStateCA = .init()
    var jobs: JobsStateCA = .init()
}

struct AuthenticationStateCA: Equatable {
    var userSession: UserSession? = nil
    var isAuthenticating: Bool = false
    var errorMessage: String? = nil
}

struct JobsStateCA: Equatable {
    var jobs: [Job] = []
    var isLoadingJobs: Bool = false
    var errorMessage: String? = nil
}

// MARK: - Actions
enum AppActionCA: Equatable {
    case authentication(action: AuthenticationActionCA)
    case jobs(action: JobsActionCA)
}

enum AuthenticationActionCA: Equatable {
    case authenticate(username: String, password: String)
    case authenticateResponse(response: Result<UserSession, AuthenticationAPIError>)
    case saveUserSession(session: UserSession)
    case saveUserSessionResponse(response: Result<UserSession, UserSessionStoreError>)
    case authenticationSucceeded(session: UserSession)
    case authenticationFailed(errorMessage: String)
}

enum JobsActionCA: Equatable {
    case loadJobs
    case reloadJobs
    case jobsResponse(response: Result<[Job], JobsAPIError>)
    case jobsLoaded(jobs: [Job])
    case failedToLoadJobs(errorMessage: String)
}

// MARK: - Environement
struct AppEnvironmentCA {
    var authenticationApi: AuthenticationAPIProtocol
    var userSessionStore: UserSessionStoreProtocol
    var jobsApi: JobsAPIProtocol
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

// MARK: - Reducer
let authenticationReducer = Reducer<AuthenticationStateCA, AuthenticationActionCA, AppEnvironmentCA> { state, action, environment in
    switch action {
    
    case .authenticate(let username, let password):
        state.errorMessage = nil
        state.isAuthenticating = true
        return environment.authenticationApi.authenticate(username: username, password: password)
            .eraseToEffect()
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(AuthenticationActionCA.authenticateResponse)
        
    case let .authenticateResponse(.success(response)):
        return Effect(value: AuthenticationActionCA.saveUserSession(session: response))
        
    case let .authenticateResponse(.failure(error)):
        return Effect(value: AuthenticationActionCA.authenticationFailed(errorMessage: "\(error)"))
        
    case .saveUserSession(let session):
        return environment.userSessionStore.saveUserSession(session)
            .eraseToEffect()
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(AuthenticationActionCA.saveUserSessionResponse)
        
    case let .saveUserSessionResponse(.success(response)):
        return Effect(value: AuthenticationActionCA.authenticationSucceeded(session: response))
        
    case let .saveUserSessionResponse(.failure(error)):
        // TODO: handle save failure
        return .none
        
    case .authenticationSucceeded(let session):
        state.isAuthenticating = false
        state.userSession = session
        return .none
        
    case .authenticationFailed(let errorMessage):
        state.isAuthenticating = false
        state.errorMessage = errorMessage
        return .none
    }
}

let jobsReducer = Reducer<JobsStateCA, JobsActionCA, AppEnvironmentCA> { state, action, environment in
    switch action {
    case .failedToLoadJobs(let message):
        state.jobs = []
        state.isLoadingJobs = false
        state.errorMessage = message
        return .none
    case .jobsLoaded(let jobs):
        state.jobs = jobs
        state.isLoadingJobs = false
        return .none
    case .loadJobs, .reloadJobs:
        state.isLoadingJobs = true
        return environment.jobsApi.loadJobs()
            .eraseToEffect()
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(JobsActionCA.jobsResponse)
        
    case let .jobsResponse(.success(jobs)):
        return Effect(value: JobsActionCA.jobsLoaded(jobs: jobs))
        
    case let .jobsResponse(.failure(error)):
        return Effect(value: JobsActionCA.failedToLoadJobs(errorMessage: "\(error)"))

    }
}


let appReducer = Reducer<AppStateCA, AppActionCA, AppEnvironmentCA>.combine(
    authenticationReducer.pullback(
        state: \AppStateCA.authentication,
        action: /AppActionCA.authentication,
        environment: { $0 }
    ),
    jobsReducer.pullback(
        state: \AppStateCA.jobs,
        action: /AppActionCA.jobs,
        environment: { $0 }
    )
)
