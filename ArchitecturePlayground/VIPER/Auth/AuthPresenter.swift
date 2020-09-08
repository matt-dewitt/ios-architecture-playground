//
//  AuthPresenter.swift
//  ArchitecturePlayground
//
//  Created by Andrew Strauss on 9/3/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation

final class AuthPresenter: PresenterProtocol {
    weak var view: AuthViewInput!
    var interactor: AuthInteractorInput
    var router: AuthRouterInput

    init(interactor: AuthInteractorInput, router: AuthRouterInput) {
        self.interactor = interactor
        self.router = router
    }

    func validate() -> String? {
        switch (view.username.isEmpty, view.password.isEmpty) {
        case (true, true):
            return "username/password required"
        case (false, true):
            return "password required"
        case (true, false):
            return "username required"
        case (false, false):
            return nil
        }
    }
}

extension AuthPresenter: AuthViewResponder {
    func handleLogin() {
        if let errorMessage = validate() {
            view.errorMessage = errorMessage
        } else {
            view.errorMessage = nil
            view.isAuthenticating = true
            interactor.login(username: view.username, password: view.password)
        }
    }
}

extension AuthPresenter: AuthInteractorResponder {
    func loginSuccessful() {
        router.navigateToJobList()
    }

    func loginFailed() {
        view.isAuthenticating = false
        view.errorMessage = "Invalid username/password"
    }
}
