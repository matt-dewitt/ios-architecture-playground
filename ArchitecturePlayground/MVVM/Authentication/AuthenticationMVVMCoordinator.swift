//
//  AuthenticationCoordinator.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class AuthenticationMVVMCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let repo = MockUserSessionRepository(authenticationApi: MockAuthenticationAPI(), userSessionStore: MockUserSessionStore())
        let viewModel = AuthenticationMVVMViewModel(userSessionRepo: repo, coordinator: self)
        let view = AuthenticationMVVMView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func navigateToJobList() {
        let coordinator = JobListMVVMCoordinator(navigationController: navigationController)
        coordinate(to: coordinator)
    }
}
