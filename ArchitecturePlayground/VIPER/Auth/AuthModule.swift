//
//  AuthModule.swift
//  ArchitecturePlayground
//
//  Created by Andrew Strauss on 9/3/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import SwiftUI

enum AuthModule: Module {
    struct Dependencies: AuthInteractorDependencies, AuthRouterDependencies {
        let userRepository: UserSessionRepositoryProtocol
        let jobsAPI: JobsAPIProtocol
    }

    typealias Interactor = AuthInteractor
    typealias Router = AuthRouter

    static func viewController(presenter: AuthPresenter, entity: Void) -> UIViewController {
        let viewModel = AuthViewModel()
        let view = AuthVIPERView(viewModel: viewModel, presenter: presenter)
        presenter.view = viewModel

        return UIHostingController(rootView: view)
    }
}

// MARK: View I/O

protocol AuthViewInput: ViewInput {
    var username: String { get }
    var password: String { get }
    var isAuthenticating: Bool { get set }
    var errorMessage: String? { get set }
}

protocol AuthViewResponder: ViewResponder {
    func handleLogin()
}

// MARK: Interactor I/O

protocol AuthInteractorInput: InteractorInput {
    func login(username: String, password: String)
}

protocol AuthInteractorResponder: InteractorResponder {
    func loginSuccessful()
    func loginFailed()
}

// MARK: Router I/O

protocol AuthRouterInput: RouterInput {
    func navigateToJobList()
}

