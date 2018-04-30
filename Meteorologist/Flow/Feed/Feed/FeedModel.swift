//
//  FeedModel.swift
//  Meteorologist
//
//  Created by Ruslan on 4/27/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import APIClient
import EventsTree

enum FeedEvent: Event {
    case typeChanged()
}

enum FeedViewAction {
    case viewLoaded
    case viewAppeared
    case refreshControlTriggered
}

protocol FeedModelInput: ControllerVisibilityOutput {
    func perform(action: FeedViewAction)
    func getNumberOfCities() -> Int
    func getChoosedCity() -> City
    func getCityNameAt(row: Int) -> String
    func setChoosedCityTo(row: Int)
    func getNumberOfRows() -> Int
    
    func feedSectionData(at index: Int) -> WeatherItem
    func changeWeatherType(to type: Int)
}

protocol FeedModelOutput: class {
    func didStartActivity(_ activity: FeedModel.Activity)
    func didFinishActivity(_ activity: FeedModel.Activity)
    func didFinishActivity(_ activity: FeedModel.Activity, with error: String)
    func setupChartWith(hourlyItems: [HourlyItem])
    func setupChartWith(dailyItems: [DailyItem])
}

class FeedModel: Model {
    
    enum Activity {
        case reload
    }
    
    weak var output: FeedModelOutput!
    
    private var choosedCity: City! = City.Dnipro {
        didSet {
            getWeatherAt(city: choosedCity)
        }
    }
    
    private var currentItemType = WeatherItemType.hourly
    
    private var cities: [City]! = [City.Dnipro, City.Dubai, City.Kanberra, City.Kiev, City.London, City.Lviv, City.NewYork, City.Odessa]
    
    var weather: Weather! = Weather() {
        didSet {
            switch currentItemType {
            case .hourly:
                output.setupChartWith(hourlyItems: weather.hourly)
            case .daily:
                output.setupChartWith(dailyItems: weather.daily)
            }
        }
    }
    
    override init(parent: EventNode?) {
        super.init(parent: parent)
    }
    
    func getWeatherAt(city: City) {
        output.didStartActivity(.reload)
        WeatherAPI.getWeatherFor(city: city) { [weak self] (weather, error) in
            if let weather = weather {
                self?.weather = weather
                self?.output.didFinishActivity(.reload)
            } else if let error = error {
                self?.output.didFinishActivity(.reload, with: error)
            }
        }
    }
}

extension FeedModel: FeedModelInput {
    func changeWeatherType(to type: Int) {
        switch type {
        case 0:
            currentItemType = .hourly
            output.setupChartWith(hourlyItems: weather.hourly)
        case 1:
            currentItemType = .daily
            output.setupChartWith(dailyItems: weather.daily)
        default:
            break
        }
    }
    
    func feedSectionData(at index: Int) -> WeatherItem {
        switch currentItemType {
        case .hourly:
            return weather.hourly[index]
        case .daily:
            return weather.daily[index]
        }
    }
    
    func setChoosedCityTo(row: Int) {
        choosedCity = cities[row]
    }
    
    func getNumberOfRows() -> Int {
        switch currentItemType {
        case .hourly:
            return weather.hourly.count
        case .daily:
            return weather.daily.count
        }
    }
    
    func getCityNameAt(row: Int) -> String {
        return cities[row].name
    }
    
    func getNumberOfCities() -> Int {
        return cities.count
    }
    
    func getChoosedCity() -> City {
        return choosedCity
    }
}

extension FeedModel: FeedViewControllerOutput {
    func perform(action: FeedViewAction) {
        switch action {
        case .refreshControlTriggered:
            getWeatherAt(city: choosedCity)
            
        case .viewLoaded:
            getWeatherAt(city: choosedCity)
        case .viewAppeared:
            getWeatherAt(city: choosedCity)
        }
    }
}
