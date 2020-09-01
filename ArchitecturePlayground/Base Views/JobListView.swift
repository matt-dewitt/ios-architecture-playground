//
//  JobListView.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import SwiftUI

struct JobListView: View {
    
    var jobs: [Job]
    var isLoadingJobs = false
    var errorMessage: String? = nil
    
    var body: some View {
        ZStack {
            if isLoadingJobs {
                Text("Please wait...")
            } else {
                if !jobs.isEmpty {
                    ScrollView {
                        VStack(spacing: 24) {
                            ForEach(jobs) { job in
                                JobListMVVMItemView(job: job) {
                                    didTapViewJob(job: job)
                                }
                            }
                        }
                        .padding(4)
                    }
                } else {
                    if let error = errorMessage {
                        VStack {
                            Text(error)
                                .foregroundColor(.red)
                            
                            Button(action:didTapReload) {
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
        .navigationBarItems(trailing: Button(action:didTapReload) { Text("Reload") })
    }
    
    private func didTapViewJob(job: Job) {
        
    }
    
    private func didTapReload() {
        
    }
}

struct JobListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            JobListView(jobs: [])
            
            JobListView(jobs: Job.mockData())
        }
    }
}

struct JobListItemView: View {
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
