//
//  WeatherItemTVC.swift
//  Meteorologist
//
//  Created by Ruslan Popesku on 3/31/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import UIKit

class WeatherItemCell: UITableViewCell, NibReusable {

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    
    func initWith(weatherItem: WeatherItem) {
        weatherImageView?.image = getImageForWeather(description: weatherItem.icon)
        summaryLabel?.text = weatherItem.summary
        humidityLabel?.text = "Humidity: \(weatherItem.humidity ?? 0)"
        pressureLabel?.text = "Pressure: \(weatherItem.pressure ?? 0)"
        windSpeed?.text = "Windspeed: \(weatherItem.windSpeed ?? 0)"
        
        if let hourlyItem = weatherItem as? HourlyItem {
            let dateFormatter = DateFormatter(withFormat: "E HH:mm", locale: "ua_UA")
            dateLabel?.text = dateFormatter.string(from: hourlyItem.time)
            temperatureLabel?.text = "\(hourlyItem.temperature.rounded(toPlaces: 2))°C"
        } else if let dailyItem = weatherItem as? DailyItem {
            let dateFormatter = DateFormatter(withFormat: "MMM d", locale: "ua_UA")
            dateLabel?.text = dateFormatter.string(from: dailyItem.time)
            temperatureLabel?.text = "\(dailyItem.temperatureLow.rounded(toPlaces: 2))°C - \(dailyItem.temperatureHigh.rounded(toPlaces: 2))°C"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func getImageForWeather(description: String) -> UIImage {
        switch description {
        case "partly-cloudy-day":
            return R.image.partlyCloudyDay()!
        case "clear-day":
            return R.image.clearDay()!
        case "partly-cloudy-night":
            return R.image.partlyCloudyNight()!
        case "cloudy":
            return R.image.cloudy()!
        case "wind":
            return R.image.wind()!
        case "snow":
            return R.image.snow()!
        case "rainy":
            return R.image.rainy()!
        default:
            return R.image.sunny2()!
        }
    }
    
}
