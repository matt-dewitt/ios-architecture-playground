//
//  Job.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation

struct Job: Identifiable {
    var id = UUID()
    var customerName: String
    var jobName: String
    var jobTime: Date
    var jobAddress: String
}

extension Job {
    static func mockData() -> [Job] {
        return [
            Job(customerName: "Jack Sparrow", jobName: "Fix leaky ship", jobTime: Date(timeIntervalSinceNow: 60 * 60 * 24 * 15), jobAddress: "Tortuga"),
            Job(customerName: "Tony Stark", jobName: "Install new garage", jobTime: Date(timeIntervalSinceNow: 60 * 60 * 24 * 30), jobAddress: "Avengers HQ"),
            Job(customerName: "Luke Skywalker", jobName: "Replace hand with mechanical", jobTime: Date(timeIntervalSinceNow: 60 * 60 * 24 * 45), jobAddress: "Tatooine, Outer Rim")
        ]
    }
}
