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
import SVProgressHUD

final class AppNavigation: EventNode {
    
    //fileprivate let userSessionController = UserSessionController(storage: UserDefaults.standard)
    fileprivate unowned let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        super.init(parent: nil)
        
        addHandler { [weak self] (event: LoginEvent) in
            if case .successfulLogin() = event {
                self?.presentMainFlow()
            }
        }
        setupSVProgressHUD()
    }
    
    func setupSVProgressHUD() {
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setBackgroundColor(UIColor.white.withAlphaComponent(0.7))
        SVProgressHUD.setForegroundColor(UIColor.lightGray)
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
    }
    
    func startFlow() {
        //if let session = userSessionController.restorePreviousSession() {
        //    presentMainFlow(with: session)
        //} else {
            presentLoginFlow()
        //}
    }
}

// MARK: Navigation

extension AppNavigation {
    
    fileprivate func presentLoginFlow() {
        let configuration = LoginFlowConfiguration(parent: self)
        let coordinator = LoginFlowCoordinator(configuration: configuration)
        presentCoordinatorFlow(coordinator)
    }
    
    fileprivate func presentMainFlow() {
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
