//
//  Module.swift
//  ArchitecturePlayground
//
//  Created by Andrew Strauss on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import UIKit

protocol Module {
    associatedtype Interactor where Interactor: InteractorProtocol, Interactor: InteractorInput
    associatedtype Presenter where Presenter: PresenterProtocol
    associatedtype Router where Router: RouterProtocol, Router: RouterInput

    associatedtype Entity = Void
    associatedtype Dependencies = Void

    static func viewController(presenter: Presenter, entity: Entity) -> UIViewController
}

extension Module {
    private static func cast<From, To>(_ some: From, to expected: To.Type) throws -> To {
        guard let valid = some as? To else {
            throw ModuleError.missingProtocolConformance(From.self, expected)
        }

        return valid
    }

    private static func cast<From, To>(_ some: From, to expected: To.Type, fallback: Any) throws -> To {
        do {
            return try cast(some, to: expected)
        } catch {
            guard let castFallback = try? cast(fallback, to: expected) else {
                throw error
            }

            return castFallback
        }
    }

    private typealias Components = (view: UIViewController, interactor: Interactor, presenter: Presenter, router: Router)

    private static func components(for entity: Entity, with dependencies: Dependencies) throws -> Components {
        let interactorEntity = try cast(entity, to: Interactor.Entity.self)
        let interactorDependencies = try cast(dependencies, to: Interactor.Dependencies.self, fallback: ())
        let routerDependencies = try cast(dependencies, to: Router.Dependencies.self, fallback: ())

        let interactor = Interactor(entity: interactorEntity, dependencies: interactorDependencies)
        let router = Router(dependencies: routerDependencies)

        let presenter = Presenter(interactor: try cast(interactor, to: Presenter.Interactor.self),
                                  router: try cast(router, to: Presenter.Router.self))
        let view = self.viewController(presenter: presenter, entity: entity)

        return (view, interactor, presenter, router)
    }
}

extension Module {
    static func build(for entity: Entity, with dependencies: Dependencies) -> UIViewController {
        do {
            let (view, _, _, router) = try self.components(for: entity, with: dependencies)

            router.viewController = view

            return view
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

extension Module where Router: PresenterResponder {
    static func build(for entity: Entity, with dependencies: Dependencies) -> UIViewController {
        do {
            let (view, _, presenter, router) = try self.components(for: entity, with: dependencies)

            router.presenter = try cast(presenter, to: Router.Presenter.self)
            router.viewController = view

            return view
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

extension Module where Interactor: PresenterResponder {
    static func build(for entity: Entity, with dependencies: Dependencies) -> UIViewController {
        do {
            let (view, interactor, presenter, router) = try self.components(for: entity, with: dependencies)

            interactor.presenter = try cast(presenter, to: Interactor.Presenter.self)

            router.viewController = view

            return view
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

extension Module where Router: PresenterResponder, Interactor: PresenterResponder {
    static func build(for entity: Entity, with dependencies: Dependencies) -> UIViewController {
        do {
            let (view, interactor, presenter, router) = try self.components(for: entity, with: dependencies)

            interactor.presenter = try cast(presenter, to: Interactor.Presenter.self)

            router.presenter = try cast(presenter, to: Router.Presenter.self)
            router.viewController = view

            return view
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
