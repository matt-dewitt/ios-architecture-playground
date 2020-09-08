//
//  View.swift
//  ArchitecturePlayground
//
//  Created by Andrew Strauss on 9/3/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation

protocol ViewProtocol {
    associatedtype Presenter

    var presenter: Presenter { get }
}

protocol ViewInput: AnyObject { }
protocol ViewResponder { }
