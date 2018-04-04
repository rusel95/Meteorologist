//
//  WeatherItemTVC.swift
//  Meteorologist
//
//  Created by Ruslan Popesku on 3/31/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import UIKit

enum ItemType {
    case hourly
    case daily
}

class WeatherItemTVC: UITableViewCell {

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    
    func initWith(hourlyItem: HourlyItem) {
        summaryLabel.text = hourlyItem.summary
        humidityLabel.text = "Humidity: \(hourlyItem.humidity ?? 0)"
        temperatureLabel.text = "Middle: \(hourlyItem.temperature.rounded(toPlaces: 2) )"
        pressureLabel.text = "Pressure: \(hourlyItem.pressure ?? 0)"
        windSpeed.text = "Windspeed: \(hourlyItem.windSpeed ?? 0)"
        
        let dateFormatter = DateFormatter(withFormat: "E HH:mm", locale: "ua_UA")
        dateLabel.text = dateFormatter.string(from: hourlyItem.time)
    }
    
    func initWith(dailyItem: DailyItem) {
        summaryLabel.text = dailyItem.summary
        humidityLabel.text = "Humidity: \(dailyItem.humidity ?? 0)"
        temperatureLabel.text = "Max: \(dailyItem.temperatureHigh.rounded(toPlaces: 2) ) Min: \(dailyItem.temperatureLow.rounded(toPlaces: 2) )"
        pressureLabel.text = "Pressure: \(dailyItem.pressure ?? 0)"
        windSpeed.text = "Windspeed: \(dailyItem.windSpeed ?? 0)"
        let dateFormatter = DateFormatter(withFormat: "MMM d", locale: "ua_UA")
        dateLabel.text = dateFormatter.string(from: dailyItem.time)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
