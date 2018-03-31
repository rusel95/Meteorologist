//
//  Weather.swift
//  Meteorologist
//
//  Created by Ruslan Popesku on 3/31/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Foundation
import ObjectMapper

class WeatherItem: Mappable {
    var time: Date!
    var summary: String!
    var icon: String!
    var temperature: Double!
    var humidity: Double!
    var pressure: Double!
    var windSpeed: Double!
    var cloudCover: Double!
    var visibility: Double!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        time <- (map["time"], DateTransform())
        summary <- map["summary"]
        icon <- map["icon"]
        temperature <- map["temperature"]
        humidity <- map["humidity"]
        pressure <- map["pressure"]
        windSpeed <- map["windSpeed"]
        cloudCover <- map["cloudCover"]
        visibility <- map["visibility"]
    }
    
}

class Weather: Mappable {
    var currently: WeatherItem!
    var hourly: [WeatherItem]!
    var daily: [WeatherItem]!
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        currently <- map["currently"]
        hourly <- map["hourly.data"]
        daily <- map["daily.data"]
    }
}
