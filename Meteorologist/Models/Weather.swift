//
//  Weather.swift
//  Meteorologist
//
//  Created by Ruslan Popesku on 3/31/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Foundation
import ObjectMapper

class HourlyItem: Mappable {
    var time: Date!
    var summary: String!
    var icon: String!
    var temperature: Double! = 0 {
        didSet {
            temperature = temperature.toCelsius()
        }
    }
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

class DailyItem: Mappable {
    var time: Date!
    var summary: String!
    var icon: String!
    var humidity: Double!
    var pressure: Double!
    var windSpeed: Double!
    var cloudCover: Double!
    var visibility: Double!
    var temperatureHigh: Double! = 0 {
        didSet {
            temperatureHigh = temperatureHigh.toCelsius()
        }
    }
    var temperatureLow: Double! = 0 {
        didSet {
            temperatureLow = temperatureLow.toCelsius()
        }
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        time <- (map["time"], DateTransform())
        summary <- map["summary"]
        icon <- map["icon"]
        temperatureHigh <- map["temperatureHigh"]
        temperatureLow <- map["temperatureLow"]
        humidity <- map["humidity"]
        pressure <- map["pressure"]
        windSpeed <- map["windSpeed"]
        cloudCover <- map["cloudCover"]
        visibility <- map["visibility"]
    }
    
}

class Weather: Mappable {
    var currently: HourlyItem!
    var hourly: [HourlyItem] = []
    var daily: [DailyItem] = []
    required init?(map: Map) {
        
    }
    init() {
        
    }
    func mapping(map: Map) {
        currently <- map["currently"]
        hourly <- map["hourly.data"]
        daily <- map["daily.data"]
    }
}
