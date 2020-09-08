//
//  ModuleError.swift
//  ArchitecturePlayground
//
//  Created by Andrew Strauss on 9/3/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation

enum ModuleError: Error {
    case missingProtocolConformance(Any.Type, Any.Type)
}

extension ModuleError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .missingProtocolConformance(invalid, missing):
            return "Failed to build Module — \(invalid) must conform to \(missing)"
        }
    }

    var failureReason: String? {
        switch self {
        case .missingProtocolConformance:
            return "Failed to build Module — required protocol conformance missing"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case let .missingProtocolConformance(invalid, missing):
            return "Add required conformance of protocol \"\(missing)\" to \(invalid)"
        }
    }
}
