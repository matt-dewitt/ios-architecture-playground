//
//  RootCAView.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/2/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct RootCAView: View {
    let store: Store<AppStateCA, AppActionCA>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            
            if viewStore.state.authentication.userSession != nil {
                NavigationView {
                    JobListCAView(store: self.store.scope(state: { $0.jobs }, action: AppActionCA.jobs))
                }
            } else {
                NavigationView {
                    AuthenticationCAView(store: self.store.scope(state: { $0.authentication }, action: AppActionCA.authentication))
                }
            }
        }
    }
}

struct RootCAView_Previews: PreviewProvider {
    
    static var previews: some View {
        RootCAView(
            store: Store(
                initialState: AppStateCA(),
                reducer: appReducer,
                environment: AppEnvironmentCA(
                    authenticationApi: MockAuthenticationAPI(),
                    userSessionStore: MockUserSessionStore(),
                    jobsApi: MockJobsAPI(),
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                )
            )
        )
    }
}

