//
//  UserSessionRepository.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation
import Combine

protocol UserSessionRepositoryProtocol {
    func authenticate(username: String, password: String) -> AnyPublisher<UserSession, UserSessionRepositoryError>
}

enum UserSessionRepositoryError: Error {
    case generic
}

class MockUserSessionRepository: UserSessionRepositoryProtocol {
    
    var authenticationApi: AuthenticationAPIProtocol
    var userSessionStore: UserSessionStoreProtocol
    
    init(authenticationApi: AuthenticationAPIProtocol, userSessionStore: UserSessionStoreProtocol) {
        self.authenticationApi = authenticationApi
        self.userSessionStore = userSessionStore
    }
    
    func authenticate(username: String, password: String) -> AnyPublisher<UserSession, UserSessionRepositoryError>  {
        return authenticationApi.authenticate(username: username, password: password)
            .mapError { (authApiError) -> UserSessionRepositoryError in
                return self.mapApiError(authApiError)
            }
            .flatMap { session in
                self.userSessionStore.saveUserSession(session)
                    .mapError { (userStoreError) -> UserSessionRepositoryError in
                        return self.mapStoreError(userStoreError)
                    }
            }
            .eraseToAnyPublisher()
    }
    
    private func mapApiError(_ error: AuthenticationAPIError) -> UserSessionRepositoryError {
        return .generic
    }
    
    private func mapStoreError(_ error: UserSessionStoreError) -> UserSessionRepositoryError {
        return .generic
    }
}
