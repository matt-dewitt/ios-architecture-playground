//
//  AuthenticationAPI.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation
import Combine

enum AuthenticationAPIError: Error {
    case unauthorized
}

protocol AuthenticationAPIProtocol  {
    func authenticate(username: String, password: String) -> AnyPublisher<UserSession, AuthenticationAPIError>
}

class MockAuthenticationAPI: AuthenticationAPIProtocol {
    func authenticate(username: String, password: String) -> AnyPublisher<UserSession, AuthenticationAPIError> {
        if username == "testy" && password == "tester" {
            let session = UserSession(username: username, authToken: UUID().uuidString)
            return Just(session)
                .setFailureType(to: AuthenticationAPIError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: AuthenticationAPIError.unauthorized)
                .eraseToAnyPublisher()
        }
    }
}
