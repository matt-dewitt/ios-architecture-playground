//
//  AuthVIPER.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 8/27/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


// MARK: - View
struct AuthView: View {
    
    @ObservedObject var viewModel: AuthViewModel
    var presenter: AuthViewToPresenterProtocol
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome")
            
            if viewModel.errorMessage != nil {
                Text("Error: \(viewModel.errorMessage!)")
            }
            
            TextField("Username", text: $viewModel.username)
            
            SecureField("Password", text: $viewModel.password)
            
            if !viewModel.isAuthenticating {
                Button(action: didTapLogin) {
                    Text("Log In")
                }
            } else {
                Text("Logging in, please wait...")
            }
        }
        .padding(20)
    }
    
    private func didTapLogin() {
        presenter.handleLogin()
    }
}

struct AuthView_Previews: PreviewProvider {
    private class PreviewPresenter: AuthViewToPresenterProtocol {
        func handleLogin() {}
    }
    
    static var previews: some View {
        Group {
            AuthView(
                viewModel: AuthViewModel(),
                presenter: PreviewPresenter()
            )
            
            AuthView(
                viewModel: AuthViewModel(
                    username: "bob",
                    password: "password",
                    isAuthenticating: true,
                    errorMessage: "Something bad happened..."
                ),
                presenter: PreviewPresenter()
            )
        }
    }
}

// MARK: - ViewModel
class AuthViewModel: ObservableObject {
    @State var username: String
    @State var password: String
    
    @Published var isAuthenticating: Bool
    @Published var errorMessage: String?
    
    init(username: String = "", password: String = "", isAuthenticating: Bool = false, errorMessage: String? = nil) {
        self.username = username
        self.password = password
        self.isAuthenticating = isAuthenticating
        self.errorMessage = errorMessage
    }
}

// MARK: - Presenter
protocol AuthViewToPresenterProtocol: class {
    func handleLogin()
}

protocol AuthInteractorToPresenterProtocol: class {
    func loginSuccessful(userSession: UserSession)
    func loginFailed(error: Error)
    func loginNeedsToChangePassword(userSession: UserSession)
}

protocol AuthRouterToPresenterProtocol: class {
    
}

class AuthPresenter {
    weak var viewModel: AuthViewModel!
    var interactor: AuthInteractorProtocol!
    var router: AuthRouterProtocol!
    
    func validate() -> Error? {
        // do form validation
        return nil
    }
    
    func formatAndDisplayError(_ error: Error) {
        let message = ""
        /*
        switch error {
        case .thisError:
            message = ""
        case .thatError:
            message = ""
        case .whateverError
            message = ""
        }
         */
        viewModel.errorMessage = message
    }
}

extension AuthPresenter: AuthViewToPresenterProtocol {
    func handleLogin() {
        if let error = validate() {
            formatAndDisplayError(error)
        } else {
            interactor.login(username: viewModel.username, password: viewModel.password)
        }
    }
}

extension AuthPresenter: AuthInteractorToPresenterProtocol {
    func loginSuccessful(userSession: UserSession) {
        router.navigateToDashboard(userSession: userSession)
    }
    
    func loginFailed(error: Error) {
        formatAndDisplayError(error)
    }
    
    func loginNeedsToChangePassword(userSession: UserSession) {
        router.navigateToChangePassword(userSession: userSession)
    }
}

extension AuthPresenter: AuthRouterToPresenterProtocol {
    
}

// MARK: - Interactor
protocol AuthInteractorProtocol {
    func login(username: String, password: String)
}

class AuthInteractor {
    weak var presenter: AuthInteractorToPresenterProtocol!
    var authAPI: AuthAPIProtocol!
    var userStore: UserStoreProtocol!
}

extension AuthInteractor: AuthInteractorProtocol {
    func login(username: String, password: String) {
        /*
         authAPI.login(username, password)
         .flatMap { userStore.saveUserSession(userSession) }
         .sink {
         .success(userSession):
         self.presenter.didRecive(userSession: userSession, error: nil)
         .failure(error):
         self.presenter.didRecive(userSession: nil, error: error)
         }
         */
        let userSession: UserSession? = UserSession(username: "", authToken: "")
        let error: Error? = nil
        
        guard let session = userSession, error == nil else {
            presenter.loginFailed(error: error!)
            return
        }
        
        
        if session.shouldChangePassword {
            presenter.loginNeedsToChangePassword(userSession: session)
        } else {
            presenter.loginSuccessful(userSession: session)
        }
    }
}

// MARK: - Router
protocol AuthRouterProtocol {
    func navigateToDashboard(userSession: UserSession)
    func navigateToChangePassword(userSession: UserSession)
}

class AuthRouter {
    weak var viewController: UIViewController!
    weak var presenter: AuthRouterToPresenterProtocol!
}

extension AuthRouter: AuthRouterProtocol {
    func navigateToDashboard(userSession: UserSession) {
        let module = DashboardModule().build(with: userSession)
        viewController.navigationController?.pushViewController(module, animated: true)
    }
    
    func navigateToChangePassword(userSession: UserSession) {
        //
    }
}

// MARK: - Module
class AuthModule {
    
    func build() -> UIViewController {
        let router = AuthRouter()
        let presenter = AuthPresenter()
        let interactor = AuthInteractor()
        let viewModel = AuthViewModel()
        
        presenter.router = router
        presenter.interactor = interactor
        
        interactor.presenter = presenter
        
        let view = AuthView(viewModel: viewModel, presenter: presenter)
        let viewController = UIHostingController(rootView: view)
        
        router.viewController = viewController
        // NOTE: everything above should happen for every module, so we should be able to generify it to work for all
        
        // NOTE: everything below would be module-specific:
        //interactor.authAPI = DIContainer.resolve(AuthAPIProtocol.self)
        //interactor.userStore = DIContainer.resolve(UserStoreProtocol.self)
        
        return viewController
    }
}

class DashboardModule {
    func build(with userSession: UserSession) -> UIViewController {
        // Implement dashboard module building, pass in userSession to interactor, etc
        return UIViewController()
    }
}



// MARK: - Services

protocol AuthAPIProtocol  {
    func login(username: String, password: String) -> AnyPublisher<UserSession?, Error>
}

protocol UserStoreProtocol {
    func saveUserSession(_ session: UserSession) -> AnyPublisher<Bool, Error>
    func getUserSession() -> AnyPublisher<UserSession?, Error>
}
