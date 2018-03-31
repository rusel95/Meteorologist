//
//  Weather.swift
//  Meteorologist
//
//  Created by Ruslan Popesku on 3/31/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Foundation
import ObjectMapper

class Weather: Mappable {
    var timezone: String?
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        timezone <- map["timezone"]
    }
}
