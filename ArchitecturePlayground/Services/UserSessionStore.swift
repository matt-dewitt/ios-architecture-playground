//
//  UserSessionStore.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation
import Combine

protocol UserSessionStoreProtocol {
    func saveUserSession(_ session: UserSession) -> AnyPublisher<UserSession, UserSessionStoreError>
    func getUserSession() -> AnyPublisher<UserSession, UserSessionStoreError>
}

enum UserSessionStoreError: Error {
    case failedToSaveUserSession
    case noUserSessionFound
}

class MockUserSessionStore: UserSessionStoreProtocol {
    private var currentUserSession: UserSession? = nil
    
    func saveUserSession(_ session: UserSession) -> AnyPublisher<UserSession, UserSessionStoreError> {
        currentUserSession = session
        if session.username == "testy" {
            return Just(session)
                .setFailureType(to: UserSessionStoreError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: UserSessionStoreError.failedToSaveUserSession)
                .eraseToAnyPublisher()
        }
    }
    
    func getUserSession() -> AnyPublisher<UserSession, UserSessionStoreError> {
        if let session = currentUserSession {
            return Just(session)
                .setFailureType(to: UserSessionStoreError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: UserSessionStoreError.noUserSessionFound)
                .eraseToAnyPublisher()
        }
    }
    
}
