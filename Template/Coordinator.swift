//
//  Coordinator.swift
//  Meteorologist
//
//  Created by Ruslan on 4/27/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Foundation
import UIKit

public protocol Coordinator {
    
    //Spice must flow!
    func createFlow() -> UIViewController
    
}
