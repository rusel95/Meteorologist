//
//  AppDelegate.swift
//  Meteorologist
//
//  Created by Ruslan Popesku on 3/31/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var appNavigationCoordinator: AppNavigation!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        appNavigationCoordinator = AppNavigation(window: window!)
        appNavigationCoordinator.startFlow()
        
        return true
    }

}

//static func setupSVProgressHUD() {
//    SVProgressHUD.setDefaultStyle(.light)
//    SVProgressHUD.setBackgroundColor(UIColor.white.withAlphaComponent(0.7))
//    SVProgressHUD.setForegroundColor(UIColor.lightGray)
//    SVProgressHUD.setMinimumDismissTimeInterval(1.5)
//    SVProgressHUD.setMaximumDismissTimeInterval(3.0)
//}
