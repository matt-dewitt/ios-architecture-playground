//
//  JobsAPI.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation
import Combine

protocol JobsAPIProtocol {
    func loadJobs() -> AnyPublisher<[Job], JobsAPIError>
}

enum JobsAPIError: Error {
    case failedToLoadJobs
}

class MockJobsAPI: JobsAPIProtocol {
    func loadJobs() -> AnyPublisher<[Job], JobsAPIError> {
        let randomInt = Int.random(in: 1..<100)
        if randomInt < 25 {
            return Fail(error: JobsAPIError.failedToLoadJobs)
                .eraseToAnyPublisher()
        } else {
            return Just(Job.mockData())
                .delay(for: 1.0, scheduler: RunLoop.main)
                .setFailureType(to: JobsAPIError.self)
                .eraseToAnyPublisher()
        }
    }
}
