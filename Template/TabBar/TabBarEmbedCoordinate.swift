//
//  TabBarEmbedCoordinate.swift
//  Meteorologist
//
//  Created by Ruslan on 4/27/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Foundation
import UIKit

public struct TabBarItemInfo {
    
    public let title: String?
    public let icon: UIImage?
    public let highlightedIcon: UIImage?
    
    public init(title: String?, icon: UIImage?, highlightedIcon: UIImage?) {
        self.title = title
        self.icon = icon
        self.highlightedIcon = highlightedIcon
    }
    
}

public protocol TabBarEmbedCoordinable: Coordinator {
    
    var tabItemInfo: TabBarItemInfo { get }
    
}

public extension TabBarEmbedCoordinable {
    
    func tabItem() -> UITabBarItem {
        return UITabBarItem(
            title: tabItemInfo.title,
            image: tabItemInfo.icon,
            selectedImage: tabItemInfo.highlightedIcon
        )
    }
    
    
}
