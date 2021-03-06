//
//  SceneDelegate.swift
//  ArchitecturePlayground
//
//  Created by Matthew DeWitt on 8/27/20.
//  Copyright © 2020 ServiceTitan. All rights reserved.
//

import UIKit
import SwiftUI
import ComposableArchitecture

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            //configureWindowForMVVM(window)
            //configureWindowForVIPER(window)
            //configureWindowForRedux(window)
            configureWindowForSCA(window)
            
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    private func configureWindowForMVVM(_ window: UIWindow) {
        let navigationController = UINavigationController()
        let authCoordinator = AuthenticationMVVMCoordinator(navigationController: navigationController)
        window.rootViewController = navigationController
        authCoordinator.start()
    }
    
    private func configureWindowForVIPER(_ window: UIWindow) {
        
    }
    
    private func configureWindowForRedux(_ window: UIWindow) {
        let state = AppStateRedux(
            authentication: AuthenticationStateRedux(),
            jobs: JobsStateRedux()
        )
        let store = StoreRedux<AppStateRedux, AppActionRedux, AppEnvironmentReduxProtocol>(
            initialState: state,
            reducer: appReducer(state:action:environment:),
            environment: AppEnvironmentRedux())

        let containerView = ContainerReduxView().environmentObject(store)
        let viewController = UIHostingController(rootView: containerView)
        window.rootViewController = viewController
    }
    
    private func configureWindowForSCA(_ window: UIWindow) {
        let store = Store(
            initialState: AppStateCA(),
            reducer: appReducer.debug(),
            environment: AppEnvironmentCA(
                authenticationApi: MockAuthenticationAPI(),
                userSessionStore: MockUserSessionStore(),
                jobsApi: MockJobsAPI(),
                mainQueue: DispatchQueue.main.eraseToAnyScheduler()
            )
        )
        let rootView = RootCAView(store: store)
        let viewController = UIHostingController(rootView: rootView)
        window.rootViewController = viewController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

