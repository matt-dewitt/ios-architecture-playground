//
//  JobDetailsMVVMViewModel.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation
import Combine

protocol JobDetailsMVVMViewModelProtocol: ObservableObject {
    var job: Job { get set }
}

class JobDetailsMVVMViewModel: JobDetailsMVVMViewModelProtocol {
    @Published var job: Job
    var coordinator: JobDetailsMVVMCoordinator
    
    init(job: Job, coordinator: JobDetailsMVVMCoordinator) {
        self.job = job
        self.coordinator = coordinator
    }
}
