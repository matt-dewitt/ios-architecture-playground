//
//  UserSession.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation

struct UserSession {
    var username: String
    var authToken: String
    var shouldChangePassword = false
}
