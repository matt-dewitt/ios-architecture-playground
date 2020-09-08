//
//  Interactor.swift
//  ArchitecturePlayground
//
//  Created by Andrew Strauss on 9/3/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation

protocol InteractorProtocol: AnyObject {
    associatedtype Entity = Void
    associatedtype Dependencies = Void

    init(entity: Entity, dependencies: Dependencies)
}

protocol InteractorInput { }
protocol InteractorResponder: AnyObject { }
