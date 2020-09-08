//
//  Presenter.swift
//  ArchitecturePlayground
//
//  Created by Andrew Strauss on 9/3/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation

protocol PresenterProtocol: AnyObject {
    associatedtype View
    associatedtype Interactor
    associatedtype Router

    var view: View! { get set }
    var interactor: Interactor { get }
    var router: Router { get }

    init(interactor: Interactor, router: Router)
}

protocol PresenterResponder: AnyObject {
    associatedtype Presenter

    var presenter: Presenter! { get set }
}
