//
//  Initializer.swift
//  Meteorologist
//
//  Created by Ruslan Popesku on 4/4/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Foundation

import SVProgressHUD

class Initializer {
    private init(){ }
    static func setupSVProgressHUD() {
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setBackgroundColor(UIColor.white.withAlphaComponent(0.7))
        SVProgressHUD.setForegroundColor(UIColor.lightGray)
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
        SVProgressHUD.setMaximumDismissTimeInterval(3.0)
    }
}
