//
//  SettingsFlowCoordinator.swift
//  Meteorologist
//
//  Created by Ruslan on 4/27/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import UIKit
import EventsTree

class SettingsFlowCoordinator: EventNode, TabBarEmbedCoordinable {
    
    let tabItemInfo = TabBarItemInfo(
        title: tr(key: .settingsTitle),
        icon: R.image.settings_icon()!,
        highlightedIcon: nil
    )
    
    private weak var navigationController: UINavigationController!
    
    func createFlow() -> UIViewController {
        let root = R.storyboard.settings.settingsVC()!
        let model = SettingsModel(parent: self)
        root.model = model
        model.output = root
        navigationController = UINavigationController(rootViewController: root)
        
        return navigationController
    }
    
    override init(parent: EventNode?) {
        super.init(parent: parent)
        
        addHandler { [weak self] (event: SettingsEvent) in
            guard let `self` = self else {
                return
            }
            
            switch event {
            case .profileSelected:
                self.presentProfileFlow()
                
            case .privacyPolicySelected:
                self.presentPrivacyPolicy()
                
            default:
                break
            }
        }
        
    }
    
    private func presentProfileFlow() {
        let coordinator = ProfileFlowCoordinator(parent: self)
        let root = coordinator.createFlow()
        navigationController.pushViewController(root, animated: true)
    }
    
    private func presentPrivacyPolicy() {
        let url = URL(string: "https://help.github.com/articles/github-privacy-statement/")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}
