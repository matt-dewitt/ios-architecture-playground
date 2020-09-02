//
//  JobListReduxView.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/2/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import SwiftUI

struct JobListReduxView: View {
    @EnvironmentObject var store: Store<AppState, AppAction, AppEnvironmentProtocol>
    
    init() {
        
    }
    
    var body: some View {
        ZStack {
            if store.state.jobs.isLoadingJobs {
                Text("Please wait...")
            } else {
                if !store.state.jobs.jobs.isEmpty {
                    ScrollView {
                        VStack(spacing: 24) {
                            ForEach(store.state.jobs.jobs) { job in
                                JobListReduxItemView(job: job)
                                    .environmentObject(store)
                            }
                        }
                        .padding(4)
                    }
                } else {
                    if let error = store.state.jobs.errorMessage {
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
        .onAppear {
            if store.state.jobs.jobs.isEmpty {
                store.send(.jobs(action:.loadJobs))
            }
        }
    }
    
    private func didTapViewJob(job: Job) {
        store.send(.jobs(action:.viewJobDetails(job: job)))
    }
    
    private func didTapTryAgain() {
        store.send(.jobs(action:.reloadJobs))
    }
}

//struct JobListReduxView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            JobListMVVMView(
//                viewModel: PreviewViewModel(
//                    jobs: Job.mockData(),
//                    isLoadingJobs: false,
//                    errorMessage: nil
//                )
//            )
//
//            JobListMVVMView(
//                viewModel: PreviewViewModel(
//                    jobs: [],
//                    isLoadingJobs: false,
//                    errorMessage: nil
//                )
//            )
//
//            JobListMVVMView(
//                viewModel: PreviewViewModel(
//                    jobs: [],
//                    isLoadingJobs: true,
//                    errorMessage: nil
//                )
//            )
//
//            JobListMVVMView(
//                viewModel: PreviewViewModel(
//                    jobs: [],
//                    isLoadingJobs: false,
//                    errorMessage: "Bad stuff happened"
//                )
//            )
//
//        }
//    }
//}

struct JobListReduxItemView: View {
    @EnvironmentObject var store: Store<AppState, AppAction, AppEnvironmentProtocol>
    
    var job: Job
    
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
            
            NavigationLink(destination: JobDetailsReduxView(job: job).environmentObject(store)) {
                Text("View Job")
                    .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(8)
                .background(Color.blue)
            }
        }
        .padding(4)
        .border(Color.gray, width: 0.5)
    }
    
    private func didTapViewJob() {
        //viewJobHandler()
    }
}

