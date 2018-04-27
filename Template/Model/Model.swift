//
//  Model.swift
//  Meteorologist
//
//  Created by Ruslan on 4/27/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Foundation
import EventsTree

open class Model: EventNode {
    
    public fileprivate(set) var isActive = false
    
}

public protocol ControllerVisibilityOutput {
    
    func controllerDidBecomeVisible()
    func controllerDidBecomeHidden()
    
}

public extension ControllerVisibilityOutput where Self: Model {
    
    func controllerDidBecomeVisible() {
        isActive = true
    }
    
    func controllerDidBecomeHidden() {
        isActive = false
    }
    
}
