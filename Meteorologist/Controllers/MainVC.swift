//
//  ViewController.swift
//  Meteorologist
//
//  Created by Ruslan Popesku on 3/31/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import UIKit
import SVProgressHUD

class MainVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityPickerView: UIPickerView!
    @IBOutlet weak var weatherTypeSegmentedControl: UISegmentedControl!
    
    @IBAction func weatherTypeChanged(_ sender: UISegmentedControl) {
        getWeatherAt(city: choosedCity)
    }
    
    var cities: [City]! = [City.Dnipro, City.Dubai, City.Kanberra, City.Kiev]
    var choosedCity: City! = City.Dnipro {
        didSet {
            getWeatherAt(city: choosedCity)
        }
    }
    
    var weatherItems: [WeatherItem]! {
        didSet {
            tableView.reloadData()
        }
    }
    
    //var weather: Weather!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(R.nib.weatherItemTVC)
        cityPickerView.delegate = self
        cityPickerView.dataSource = self
        
        getWeatherAt(city: choosedCity)
    }
    
    func getWeatherAt(city: City) {
        WeatherAPI.getWeatherFor(city: City.Dnipro) { [unowned self] (weather, error) in
            if let weather = weather {
                weatherTypeSegmentedControl.selectedSegmentIndex == 0 ? weatherItems = weather.hourly : weatherItems = weather.daily
            } else if let error = error {
                SVProgressHUD.show(withStatus: error)
            }
        }
    }


}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.weatherItemTVC, for: indexPath)
        cell?.weatherItem = weatherItems[indexPath.row]
        return cell ?? UITableViewCell()
    }
}

extension MainVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choosedCity = cities[row]
    }
    
}
