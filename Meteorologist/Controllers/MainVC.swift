//
//  ViewController.swift
//  Meteorologist
//
//  Created by Ruslan Popesku on 3/31/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import UIKit
import SVProgressHUD
import Charts


class MainVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityPickerView: UIPickerView!
    @IBOutlet weak var weatherTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var weatherChartView: LineChartView!
    
    @IBAction func weatherTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentItemType = .hourly
            setupChartWith(hourlyItems: weather.hourly)
        case 1:
            currentItemType = .daily
            setupChartWith(dailyItems: weather.daily)
        default:
            break
        }
        tableView.reloadData()
    }
    
    var cities: [City]! = [City.Dnipro, City.Dubai, City.Kanberra, City.Kiev, City.London, City.Lviv, City.NewYork, City.Odessa]
    var choosedCity: City! = City.Dnipro {
        didSet {
            getWeatherAt(city: choosedCity)
        }
    }
    
    var currentItemType = ItemType.hourly
    
    var weather: Weather! = Weather() {
        didSet {
            tableView.reloadData()
            switch currentItemType {
            case .hourly:
                self.setupChartWith(hourlyItems: weather.hourly)
            case .daily:
                self.setupChartWith(dailyItems: weather.daily)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(R.nib.weatherItemTVC)
        cityPickerView.delegate = self
        cityPickerView.dataSource = self
        weatherChartView.delegate = self
        getWeatherAt(city: choosedCity)
    }
    
    func getWeatherAt(city: City) {
        SVProgressHUD.show()
        WeatherAPI.getWeatherFor(city: city) { [unowned self] (weather, error) in
            if let weather = weather {
                SVProgressHUD.dismiss()
                self.weather = weather
            } else if let error = error {
                SVProgressHUD.show(withStatus: error)
            }
        }
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentItemType {
        case .hourly:
            return weather.hourly.count
        case .daily:
            return weather.daily.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.weatherItemTVC, for: indexPath)!
        switch currentItemType {
        case .hourly:
            cell.initWith(hourlyItem: weather.hourly[indexPath.row])
        case .daily:
            cell.initWith(dailyItem: weather.daily[indexPath.row])
        }
        return cell
    }
}

extension MainVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String( cities[row].name )
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choosedCity = cities[row]
    }
    
}
