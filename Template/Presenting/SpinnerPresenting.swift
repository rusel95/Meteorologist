//
//  SpinnerPresenting.swift
//  Meteorologist
//
//  Created by Ruslan on 4/27/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Foundation

public protocol SpinnerPresenting {
    
    func showSpinner(message: String?, blockUI: Bool)
    func hideSpinner()
    
}
