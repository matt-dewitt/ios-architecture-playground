//
//  JobDetailsReduxView.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/2/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import SwiftUI

struct JobDetailsReduxView: View {
    @EnvironmentObject var store: Store<AppState, AppAction, AppEnvironmentProtocol>
    var job: Job
    
    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "M/d/y HH:mm"
        return df
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            VStack() {
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
            
            VStack(alignment: .leading) {
                Text("Forms:")
                    .font(.footnote)
                
                Text("None found")
                    .font(.footnote)
            }
            
            VStack(alignment: .leading) {
                Text("History:")
                    .font(.footnote)
                
                Text("None found")
                    .font(.footnote)
            }
            
            VStack(alignment: .leading) {
                Text("Invoices:")
                    .font(.footnote)
                
                Text("None found")
                    .font(.footnote)
            }
            
            VStack(alignment: .leading) {
                Text("Photos:")
                    .font(.footnote)
                
                Text("None found")
                    .font(.footnote)
            }

        }
        .padding(4)
        .navigationTitle("Job Details")
    }
}

//struct JobDetailsReduxView_Previews: PreviewProvider {
//    private class PreviewViewModel: JobDetailsMVVMViewModelProtocol {
//        var job: Job
//
//        init(job: Job) {
//            self.job = job
//        }
//    }
//
//    static var previews: some View {
//        JobDetailsMVVMView(viewModel: PreviewViewModel(job: Job.mockData()[0]))
//    }
//}

