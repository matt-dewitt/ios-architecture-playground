//
//  AuthenticationMVVMViewModel.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

protocol AuthenticationMVVMViewModelProtocol: ObservableObject {
    var username: String { get set }
    var password: String { get set }
    var isAuthenticating: Bool { get set }
    var errorMessage: String? { get set }
    
    func authenticate()
}

class AuthenticationMVVMViewModel: AuthenticationMVVMViewModelProtocol {
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isAuthenticating: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    var userSessionRepo: UserSessionRepositoryProtocol
    var coordinator: AuthenticationMVVMCoordinator
    
    init(userSessionRepo: UserSessionRepositoryProtocol, coordinator: AuthenticationMVVMCoordinator) {
        self.userSessionRepo = userSessionRepo
        self.coordinator = coordinator
    }
    
    func authenticate() {
        isAuthenticating = true
        userSessionRepo.authenticate(username: username, password: password)
            .sinkToResult { (result) in
                switch result {
                case .success(_):
                    self.completeAuthentication()
                case let .failure(error):
                    self.formatAndDisplay(error: error)
                }
                self.isAuthenticating = false
            }
            .store(in: &cancellables)
    }
    
    func formatAndDisplay(error: UserSessionRepositoryError) {
        errorMessage = "Something bad happened:\n\(error.localizedDescription)"
    }
    
    func completeAuthentication() {
        coordinator.navigateToJobList()
    }
}
