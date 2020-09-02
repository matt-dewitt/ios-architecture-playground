//
//  JobListCAView.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/2/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct JobListCAView: View {
    let store: Store<JobsStateCA, JobsActionCA>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                if viewStore.state.isLoadingJobs {
                    Text("Please wait...")
                } else {
                    if !viewStore.state.jobs.isEmpty {
                        ScrollView {
                            VStack(spacing: 24) {
                                ForEach(viewStore.state.jobs) { job in
                                    JobListCAItemView(job: job)
                                }
                            }
                            .padding(4)
                        }
                    } else {
                        if let error = viewStore.state.errorMessage {
                            VStack {
                                Text(error)
                                    .foregroundColor(.red)
                                
                                Button(action:{
                                    viewStore.send(.reloadJobs)
                                }) {
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
            .navigationBarItems(
                leading: Button(action:{ /* TODO: send auth action */ }) { Text("Sign Out") },
                trailing: Button(action:{ viewStore.send(.reloadJobs) }) { Text("Reload") }
            )
            .onAppear {
                if viewStore.state.jobs.isEmpty {
                    viewStore.send(.loadJobs)
                }
            }
        }
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

struct JobListCAItemView: View {
    
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
            
            NavigationLink(destination: JobDetailsCAView(job: job)) {
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
    
}

