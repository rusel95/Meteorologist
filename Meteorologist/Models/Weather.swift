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
        humidity <- map["humidity"]
        pressure <- map["pressure"]
        windSpeed <- map["windSpeed"]
        cloudCover <- map["cloudCover"]
        visibility <- map["visibility"]
    }
    
}

class HourlyItem: WeatherItem {
    var temperature: Double! = 0 {
        didSet {
            temperature = temperature.toCelsius()
        }
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        temperature <- map["temperature"]
    }
    
}

class DailyItem: WeatherItem {
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
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        temperatureHigh <- map["temperatureHigh"]
        temperatureLow <- map["temperatureLow"]
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
