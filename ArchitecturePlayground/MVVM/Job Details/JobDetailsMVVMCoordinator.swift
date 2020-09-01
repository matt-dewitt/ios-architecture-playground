//
//  JobDetailsMVVMCoordinator.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class JobDetailsMVVMCoordinator: Coordinator {
    var navigationController: UINavigationController
    var job: Job
    
    init(navigationController: UINavigationController, job: Job) {
        self.navigationController = navigationController
        self.job = job
    }
    
    func start() {
        let viewModel = JobDetailsMVVMViewModel(job: job, coordinator: self)
        let view = JobDetailsMVVMView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        navigationController.pushViewController(viewController, animated: true)
    }

}
