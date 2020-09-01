//
//  JobListMVVMView.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import SwiftUI

struct JobListMVVMView<ViewModel: JobListMVVMViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            if viewModel.isLoadingJobs {
                Text("Please wait...")
            } else {
                if !viewModel.jobs.isEmpty {
                    ScrollView {
                        VStack(spacing: 24) {
                            ForEach(viewModel.jobs) { job in
                                JobListMVVMItemView(job: job) {
                                    didTapViewJob(job: job)
                                }
                            }
                        }
                        .padding(4)
                    }
                } else {
                    if let error = viewModel.errorMessage {
                        VStack {
                            Text(error)
                                .foregroundColor(.red)
                            
                            Button(action:didTapTryAgain) {
                                Text("Try Again")
                            }
                        }
                    } else {
                        Text("No jobs found")
                    }
                }
            }
        }
        .navigationTitle("Jobs")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing: Button(action:didTapTryAgain) { Text("Reload") })
    }
    
    private func didTapViewJob(job: Job) {
        viewModel.viewJobDetails(job: job)
    }
    
    private func didTapTryAgain() {
        viewModel.loadJobs()
    }
}

struct JobListMVVMView_Previews: PreviewProvider {
    private class PreviewViewModel: JobListMVVMViewModelProtocol {
        var jobs: [Job]
        var isLoadingJobs: Bool = false
        var errorMessage: String? = nil
        
        func loadJobs() {}
        func viewJobDetails(job: Job) {}
        
        init(jobs: [Job], isLoadingJobs: Bool, errorMessage: String?) {
            self.jobs = jobs
            self.isLoadingJobs = isLoadingJobs
            self.errorMessage = errorMessage
        }
    }
    
    static var previews: some View {
        Group {
            JobListMVVMView(
                viewModel: PreviewViewModel(
                    jobs: Job.mockData(),
                    isLoadingJobs: false,
                    errorMessage: nil
                )
            )
            
            JobListMVVMView(
                viewModel: PreviewViewModel(
                    jobs: [],
                    isLoadingJobs: false,
                    errorMessage: nil
                )
            )
            
            JobListMVVMView(
                viewModel: PreviewViewModel(
                    jobs: [],
                    isLoadingJobs: true,
                    errorMessage: nil
                )
            )
            
            JobListMVVMView(
                viewModel: PreviewViewModel(
                    jobs: [],
                    isLoadingJobs: false,
                    errorMessage: "Bad stuff happened"
                )
            )
            
        }
    }
}

struct JobListMVVMItemView: View {
    var job: Job
    var viewJobHandler: () -> Void
    
    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "M/d/y HH:mm"
        return df
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading) {
                Text(job.customerName)
                    .font(.headline)
                
                Text(job.jobName)
                    .font(.subheadline)
            }
            
            HStack(spacing: 16) {
                VStack(alignment: .leading) {
                    Text("Time:")
                        .font(.footnote)
                    
                    Text(dateFormatter.string(from: job.jobTime))
                        .font(.footnote)
                }
                
                VStack(alignment: .leading) {
                    Text("Address:")
                        .font(.footnote)
                    
                    Text(job.jobAddress)
                        .font(.footnote)
                }
            }
            
            Button(action: didTapViewJob) {
                Text("View Job")
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(8)
            .background(Color.blue)
        }
        .padding(4)
        .border(Color.gray, width: 0.5)
    }
    
    private func didTapViewJob() {
        viewJobHandler()
    }
}
