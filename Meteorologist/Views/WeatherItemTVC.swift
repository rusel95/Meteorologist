//
//  WeatherItemTVC.swift
//  Meteorologist
//
//  Created by Ruslan Popesku on 3/31/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import UIKit

class WeatherItemTVC: UITableViewCell {

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    
    var weatherItem: WeatherItem! {
        didSet {
            let dateFormatter = DateFormatter(withFormat: "yyyy-MM-dd", locale: "ua_UA")
            dateLabel.text = dateFormatter.string(from: weatherItem.time)
            summaryLabel.text = weatherItem.summary
            humidityLabel.text = String(weatherItem.humidity)
            temperatureLabel.text = String(weatherItem.temperature ?? 0.0)
            pressureLabel.text = String(weatherItem.pressure)
            windSpeed.text = String(weatherItem.windSpeed)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
