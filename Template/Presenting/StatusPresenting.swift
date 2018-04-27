//
//  StatusPresenting.swift
//  Meteorologist
//
//  Created by Ruslan on 4/27/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Foundation

public protocol StatusPresenting {
    
    func presentError(message: String)
    func presentSuccess(message: String)
    func presentStatus(message: String)
    
}
