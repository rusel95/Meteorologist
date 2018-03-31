//
//  ViewController.swift
//  Meteorologist
//
//  Created by Ruslan Popesku on 3/31/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        WeatherAPI.getWeatherFor(city: Cities.Dnipro) { (weather, error) in
            print(weather?.daily.last?.time)
        }
    }


}

