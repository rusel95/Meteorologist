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

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
