//
//  AppNavigation.swift
//  Meteorologist
//
//  Created by Ruslan on 4/27/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Foundation
import UIKit
import EventsTree

final class AppNavigation: EventNode {
    
    //fileprivate let userSessionController = UserSessionController(storage: UserDefaults.standard)
    fileprivate unowned let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        
        super.init(parent: nil)
        
        addHandler { [weak self] (event: LoginEvent) in
            if case .successfulLogin(let userSession) = event {
                self?.presentMainFlow(with: userSession)
            }
        }
        
    }
    
    func startFlow() {
        if let session = userSessionController.restorePreviousSession() {
            presentMainFlow(with: session)
        } else {
            presentLoginFlow()
        }
    }
}

// MARK: Navigation

extension AppNavigation {
    
    fileprivate func presentLoginFlow() {
        let configuration = AuthFlowConfiguration(parent: self, userSessionController: userSessionController)
        let coordinator = AuthFlowCoordinator(configuration: configuration)
        presentCoordinatorFlow(coordinator)
    }
    
    fileprivate func presentMainFlow(with: UserSession) {
        let coordinator = TabBarCoordinator(parent: self)
        let feedFlow = FeedFlowCoordinator(parent: coordinator)
        let settingsFlow = SettingsFlowCoordinator(parent: coordinator)
        presentCoordinatorFlow(coordinator)
        coordinator.addTabCoordinators(coordinators: [feedFlow, settingsFlow])
    }
    
    private func presentCoordinatorFlow(_ coordinator: Coordinator) {
        let root = coordinator.createFlow()
        window.rootViewController = root
        window.makeKeyAndVisible()
    }
    
}
