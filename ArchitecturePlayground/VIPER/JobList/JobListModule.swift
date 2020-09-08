//
//  JobListModule.swift
//  ArchitecturePlayground
//
//  Created by Andrew Strauss on 9/3/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation

enum JobListModule: Module {
    struct Dependencies {
        let userRepository: UserSessionRepositoryProtocol
        let jobsAPI: JobsAPIProtocol
    }

    typealias Interactor = JobListInteractor
    typealias Router = JobListRouter

    static func viewController(presenter: JobListPresenter, entity: Void) -> UIViewController {
        let viewModel = JobListViewModel()
        let view = JobListVIPERView(viewModel: viewModel, presenter: presenter)
        presenter.view = viewModel

        return UIHostingController(rootView: view)
    }
}

// MARK: View I/O

protocol JobListViewInput: ViewInput {
}

protocol JobListViewResponder: ViewResponder {
}

// MARK: Interactor I/O

protocol JobListInteractorInput: InteractorInput {
}

protocol JobListInteractorResponder: InteractorResponder {
}

// MARK: Router I/O

protocol JobListRouterInput: RouterInput {
}


import SwiftUI

class JobListViewModel: ObservableObject, JobListViewInput {

}

struct JobListVIPERView: View, ViewProtocol {
    @ObservedObject var viewModel: JobListViewModel
    var presenter: JobListViewResponder

    var body: some View {
        EmptyView()
    }
}

final class JobListPresenter: PresenterProtocol {
    weak var view: JobListViewInput!
    var interactor: JobListInteractorInput
    var router: JobListRouterInput

    init(interactor: JobListInteractorInput, router: JobListRouterInput) {
        self.interactor = interactor
        self.router = router
    }
}

extension JobListPresenter: JobListViewResponder { }
extension JobListPresenter: JobListInteractorResponder { }

protocol JobListInteractorDependencies {

}

final class JobListInteractor: InteractorProtocol, PresenterResponder {
    weak var presenter: JobListInteractorResponder!

    init(entity: Void, dependencies: JobListInteractorDependencies) {

    }
}

extension JobListInteractor: JobListInteractorInput { }

protocol JobListRouterDependencies {

}

final class JobListRouter: RouterProtocol {
    weak var viewController: UIViewController!

    init(dependencies: JobListRouterDependencies) {

    }
}

extension JobListRouter: JobListRouterInput { }
