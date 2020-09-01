//
//  Reducer.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation
import Combine

typealias Reducer<State, Action, Environment> = (inout State, Action, Environment) -> AnyPublisher<Action, Never>?

func appReducer(state: inout AppState, action: AppAction, environment: AppEnvironmentProtocol) -> AnyPublisher<AppAction, Never>? {
    switch action {
    case let .authentication(action):
        return authenticationReducer(state: &state.authentication, action: action, environment: environment)
    case let .jobs(action):
        return jobsReducer(state: &state.jobs, action: action, environment: environment)
    }
}


func authenticationReducer(state: inout AuthenticationState, action: AuthenticationAction, environment: AppEnvironmentProtocol) -> AnyPublisher<AppAction, Never>?  {
    switch action {
    case .authenticate(let username, let password):
        state.isAuthenticating = true
        return environment.services.authenticationApi
            .authenticate(username: username, password: password)
            .catch {
                Just(UserSession(error: "\($0)"))
            }
            .map {
                if let err = $0.error {
                    return .authentication(action: AuthenticationAction.authenticationFailed(errorMessage: err))
                } else {
                    return .authentication(action: AuthenticationAction.saveUserSession(session: $0))
                }
            }
            .eraseToAnyPublisher()
        
    case .authenticationFailed(let errorMessage):
        state.errorMessage = errorMessage
        state.isAuthenticating = false
        
    case .saveUserSession(let session):
        return environment.services.userSessionStore.saveUserSession(session)
            .replaceError(with: session)
            .map { .authentication(action: AuthenticationAction.authenticationSucceeded(session: $0)) }
            .eraseToAnyPublisher()
    
    case .authenticationSucceeded(let session):
        state.userSession = session
        state.isAuthenticating = false

    }
    return nil
}

func jobsReducer(state: inout JobsState, action: JobsAction, environment: AppEnvironmentProtocol) -> AnyPublisher<AppAction, Never>? {
    // Implement your state changes here
}


//    case let .setSearchResults(repos):
//        state.searchResult = repos
//    case let .search(query):
//        return environment.service
//            .searchPublisher(matching: query)
//            .replaceError(with: [])
//            .map { AppAction.setSearchResults(repos: $0) }
//            .eraseToAnyPublisher()
