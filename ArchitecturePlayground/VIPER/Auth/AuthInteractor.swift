//
//  AuthInteractor.swift
//  ArchitecturePlayground
//
//  Created by Andrew Strauss on 9/3/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Combine

protocol AuthInteractorDependencies {
    var userRepository: UserSessionRepositoryProtocol { get }
}

final class AuthInteractor: InteractorProtocol, PresenterResponder {
    weak var presenter: AuthInteractorResponder!
    var repository: UserSessionRepositoryProtocol
    private var authenticationRequest: AnyCancellable?

    init(entity: Void, dependencies: AuthInteractorDependencies) {
        repository = dependencies.userRepository
    }
}

extension AuthInteractor: AuthInteractorInput {
    func login(username: String, password: String) {
        authenticationRequest = repository.authenticate(username: username, password: password)
            .sinkToResult { (result) in
                switch result {
                case .success:
                    self.presenter.loginSuccessful()
                case .failure:
                    self.presenter.loginFailed()
                }
            }
    }
}
