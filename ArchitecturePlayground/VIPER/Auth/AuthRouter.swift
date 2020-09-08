//
//  AuthRouter.swift
//  ArchitecturePlayground
//
//  Created by Andrew Strauss on 9/3/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import UIKit

protocol AuthRouterDependencies {
    var userRepository: UserSessionRepositoryProtocol { get }
    var jobsAPI: JobsAPIProtocol { get }
}

final class AuthRouter: RouterProtocol {
    weak var viewController: UIViewController!
    var api: JobsAPIProtocol
    var repository: UserSessionRepositoryProtocol

    init(dependencies: AuthRouterDependencies) {
        self.api = dependencies.jobsAPI
        self.repository = dependencies.userRepository
    }
}

extension AuthRouter: AuthRouterInput {
    func navigateToJobList() {
        let jobList = JobListModule.build(for: (), with: .init(userRepository: repository, jobsAPI: api))
        viewController.navigationController?.pushViewController(jobList, animated: true)
    }
}
