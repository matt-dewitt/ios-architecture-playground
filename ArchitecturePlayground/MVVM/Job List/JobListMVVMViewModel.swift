//
//  JobListMVVMViewModel.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation
import Combine

protocol JobListMVVMViewModelProtocol: ObservableObject {
    var jobs: [Job] { get set }
    var isLoadingJobs: Bool { get set }
    var errorMessage: String? { get set }
    
    func loadJobs()
    func viewJobDetails(job: Job)
}

class JobListMVVMViewModel: JobListMVVMViewModelProtocol {
    @Published var jobs: [Job] = []
    @Published var isLoadingJobs: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    var jobsApi: JobsAPIProtocol
    var coordinator: JobListMVVMCoordinator
    
    init(jobsApi: JobsAPIProtocol, coordinator: JobListMVVMCoordinator) {
        self.jobsApi = jobsApi
        self.coordinator = coordinator
        
        loadJobs()
    }
    
    func loadJobs() {
        isLoadingJobs = true
        jobs = []
        jobsApi.loadJobs()
            .sinkToResult { result in
                switch result {
                case let .success(jobs):
                    self.jobs = jobs
                case let .failure(error):
                    self.formatAndDisplay(error: error)
                }
                self.isLoadingJobs = false
            }
            .store(in: &cancellables)
    }
    
    func formatAndDisplay(error: JobsAPIError) {
        errorMessage = "Couldn't load jobs:\n\(error.localizedDescription)"
    }
    
    func viewJobDetails(job: Job) {
        coordinator.navigateToJobDetail(job: job)
    }
}
