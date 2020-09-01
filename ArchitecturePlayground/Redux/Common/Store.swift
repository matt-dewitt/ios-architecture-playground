//
//  Store.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import Foundation
import Combine

final class Store<State, Action, Environment>: ObservableObject {
    @Published private(set) var state: State

    private let environment: Environment
    private let reducer: Reducer<State, Action, Environment>
    private var cancellables: Set<AnyCancellable> = []

    init(
        initialState: State,
        reducer: @escaping Reducer<State, Action, Environment>,
        environment: Environment
    ) {
        self.state = initialState
        self.reducer = reducer
        self.environment = environment
    }

    func send(_ action: Action) {
        guard let effect = reducer(&state, action, environment) else {
            return
        }

        effect
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: send)
            .store(in: &cancellables)
    }
    
    private var derivedCancellable: AnyCancellable?

    func derived<DerivedState: Equatable, DerivedAction, Void>(deriveState: @escaping (State) -> DerivedState, deriveAction: @escaping (DerivedAction) -> Action) -> Store<DerivedState, DerivedAction, Void> {
        let store = Store<DerivedState, DerivedAction, Void>(
            initialState: deriveState(state),
            reducer: { _, action, _ in
                self.send(deriveAction(action))
                return Empty(completeImmediately: true)
                    .eraseToAnyPublisher()
            },
            environment: () as! Void
        )

        store.derivedCancellable = $state
            .map(deriveState)
            .removeDuplicates()
            .sink { [weak store] in store?.state = $0 }

        return store
    }
}
