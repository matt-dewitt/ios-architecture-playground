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
            NavigationView {
                if viewStore.state.authentication.userSession != nil {
                    JobListCAView(store: self.store.scope(state: { $0.jobs }, action: AppActionCA.jobs))
                } else {
                    AuthenticationCAView(store: self.store.scope(state: { $0.authentication }, action: AppActionCA.authentication))
                }
            }
        }
    }
}

//struct RootCAView_Previews: PreviewProvider {
//    static var previews: some View {
//        RootCAView()
//    }
//}

/*
 NavigationView {
     if store.state.authentication.userSession != nil {
         JobListReduxView()
             .environmentObject(store)
     } else {
         AuthenticationReduxView()
             .environmentObject(store)
     }
 }
 */
