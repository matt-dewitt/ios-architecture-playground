//
//  ContainerReduxView.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 9/1/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import SwiftUI

struct ContainerReduxView: View {
    @EnvironmentObject var store: Store<AppState, AppAction, AppEnvironmentProtocol>
    
    var body: some View {
        if store.state.authentication.userSession != nil {
            Text("You signed in!")
        } else {
            AuthenticationReduxView()
                .environmentObject(store)
        }
    }

}

struct ContainerReduxView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerReduxView()
    }
}
