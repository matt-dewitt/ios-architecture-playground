//
//  UserSession.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation

struct UserSession: Equatable {
    var username: String
    var authToken: String
    var shouldChangePassword = false
    var error: String?
    
    init(username: String, authToken: String) {
        self.username = username
        self.authToken = authToken
    }
    
    init(error: String) {
        self.username = ""
        self.authToken = ""
        self.error = error
    }
}
