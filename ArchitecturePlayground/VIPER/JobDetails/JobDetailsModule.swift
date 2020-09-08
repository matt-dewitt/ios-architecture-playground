//
//  JobDetailsModule.swift
//  ArchitecturePlayground
//
//  Created by Andrew Strauss on 9/3/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation

enum JobDetailsModule: Module {
    struct Dependencies {
        let userRepository: UserSessionRepositoryProtocol
        let jobsAPI: JobsAPIProtocol
    }

    typealias Interactor = JobDetailsInteractor
    typealias Router = JobDetailsRouter

    static func viewController(presenter: JobDetailsPresenter, entity: Void) -> UIViewController {
        let viewModel = JobDetailsViewModel()
        let view = JobDetailsVIPERView(viewModel: viewModel, presenter: presenter)
        presenter.view = viewModel

        return UIHostingController(rootView: view)
    }
}

// MARK: View I/O

protocol JobDetailsViewInput: ViewInput {
}

protocol JobDetailsViewResponder: ViewResponder {
}

// MARK: Interactor I/O

protocol JobDetailsInteractorInput: InteractorInput {
}

protocol JobDetailsInteractorResponder: InteractorResponder {
}

// MARK: Router I/O

protocol JobDetailsRouterInput: RouterInput {
}


import SwiftUI

class JobDetailsViewModel: ObservableObject, JobDetailsViewInput {

}

struct JobDetailsVIPERView: View, ViewProtocol {
    @ObservedObject var viewModel: JobDetailsViewModel
    var presenter: JobDetailsViewResponder

    var body: some View {
        EmptyView()
    }
}

final class JobDetailsPresenter: PresenterProtocol {
    weak var view: JobDetailsViewInput!
    var interactor: JobDetailsInteractorInput
    var router: JobDetailsRouterInput

    init(interactor: JobDetailsInteractorInput, router: JobDetailsRouterInput) {
        self.interactor = interactor
        self.router = router
    }
}

extension JobDetailsPresenter: JobDetailsViewResponder { }
extension JobDetailsPresenter: JobDetailsInteractorResponder { }

protocol JobDetailsInteractorDependencies {

}

final class JobDetailsInteractor: InteractorProtocol, PresenterResponder {
    weak var presenter: JobDetailsInteractorResponder!

    init(entity: Void, dependencies: JobDetailsInteractorDependencies) {

    }
}

extension JobDetailsInteractor: JobDetailsInteractorInput { }

protocol JobDetailsRouterDependencies {

}

final class JobDetailsRouter: RouterProtocol {
    weak var viewController: UIViewController!

    init(dependencies: JobDetailsRouterDependencies) {

    }
}

extension JobDetailsRouter: JobDetailsRouterInput { }
