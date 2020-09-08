//
//  Router.swift
//  ArchitecturePlayground
//
//  Created by Andrew Strauss on 9/3/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import UIKit

protocol RouterProtocol: AnyObject {
    associatedtype Dependencies = Void

    var viewController: UIViewController! { get set }

    init(dependencies: Dependencies)
}

protocol RouterInput { }
protocol RouterResponder: AnyObject { }
