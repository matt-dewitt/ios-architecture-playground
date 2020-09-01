//
//  JobListMVVMCoordinator.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class JobListMVVMCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let api = MockJobsAPI()
        let viewModel = JobListMVVMViewModel(jobsApi: api, coordinator: self)
        let view = JobListMVVMView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func navigateToJobDetail(job: Job) {
        let coordinator = JobDetailsMVVMCoordinator(navigationController: navigationController, job: job)
        coordinate(to: coordinator)
    }
}
