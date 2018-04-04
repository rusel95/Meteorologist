//
//  Extensions.swift
//  Meteorologist
//
//  Created by Ruslan Popesku on 4/4/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Foundation

extension Double {
    func toCelsius() -> Double {
        return (self - 32.0) * 5.0 / 9.0
    }
}
