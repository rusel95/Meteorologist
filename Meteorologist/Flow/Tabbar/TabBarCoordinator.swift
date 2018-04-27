//
//  TabBarCoordinator.swift
//  Meteorologist
//
//  Created by Ruslan on 4/27/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import UIKit
import EventsTree

class TabBarCoordinator: EventNode, Coordinator {
    
    private weak var root: TabBarController!
    
    func createFlow() -> UIViewController {
        let tabBarController = R.storyboard.tabBar.tabbarVC()!
        let model = TabBarModel(parent: self)
        tabBarController.model = model
        model.output = tabBarController
        
        root = tabBarController
        
        return tabBarController
    }
    
    func addTabCoordinators(coordinators: [TabBarEmbedCoordinable]) {
        var controllers = [UIViewController]()
        var tabItemMap = [(controller: UIViewController, tabItem: UITabBarItem)]()
        for coordinator in coordinators {
            let controller = coordinator.createFlow()
            let tabItem = coordinator.tabItem()
            tabItemMap.append((controller: controller, tabItem: tabItem))
            controllers.append(controller)
        }
        
        root.configureTabs(with: tabItemMap)
    }
    
}
