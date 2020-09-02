//
//  ContainerReduxView.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import SwiftUI

struct ContainerReduxView: View {
    @EnvironmentObject var store: StoreRedux<AppStateRedux, AppActionRedux, AppEnvironmentReduxProtocol>
    
    var body: some View {
        NavigationView {
            if store.state.authentication.userSession != nil {
                JobListReduxView()
                    .environmentObject(store)
            } else {
                AuthenticationReduxView()
                    .environmentObject(store)
            }
        }
    }
    
}

struct ContainerReduxView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerReduxView()
    }
}
