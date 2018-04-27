//
//  FeedFlowCoordinator.swift
//  Meteorologist
//
//  Created by Ruslan on 4/27/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Foundation
import UIKit
import EventsTree

class FeedFlowCoordinator: EventNode, TabBarEmbedCoordinable {
    
    let tabItemInfo = TabBarItemInfo(
        title: tr(key: .feedTabbarTitle),
        icon: UIImage(asset: .feedIcon),
        highlightedIcon: nil
    )
    
    fileprivate weak var root: FeedViewController!
    
    override init(parent: EventNode?) {
        super.init(parent: parent)
        
        addHandler([.onRaise, .consumeEvent]) { [weak self] (event: FeedEvent) in
            if case .repositorySelected(let repository) = event {
                self?.presentDetailedRepository(repository)
            }
        }
        
        addHandler { [weak self] (event: RepositoryDetailsEvent) in
            guard let `self` = self, case .transitionToRepositoriesAccepted = event else {
                return
            }
            
            self.root.navigationController!.popViewController(animated: true)
        }
    }
    
    func createFlow() -> UIViewController {
        root = StoryboardScene.Feed.instantiateFeedViewController()
        let model = FeedModel(parent: self)
        root.model = model
        model.output = root
        
        return UINavigationController(rootViewController: root)
    }
    
}

extension FeedFlowCoordinator {
    
    fileprivate func presentDetailedRepository(_ repository: Repository) {
        let controller = StoryboardScene.Feed.instantiateRepositoryDetails()
        let model = RepositoryDetailsModel(parent: self, repository: repository)
        controller.model = model
        model.output = controller
        root.navigationController!.pushViewController(controller, animated: true)
    }
    
}
