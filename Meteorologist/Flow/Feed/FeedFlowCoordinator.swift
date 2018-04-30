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
        icon: R.image.feed_icon()!,
        highlightedIcon: nil
    )
    
    fileprivate weak var root: FeedViewController!
    
    override init(parent: EventNode?) {
        super.init(parent: parent)
    
    }
    
    func createFlow() -> UIViewController {
        root = R.storyboard.feed.feedVC()!
        let model = FeedModel(parent: self)
        root.model = model
        model.output = root
        
        return UINavigationController(rootViewController: root)
    }
    
}
