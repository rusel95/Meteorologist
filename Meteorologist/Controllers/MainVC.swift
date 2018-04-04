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
        if sender.selectedSegmentIndex == 0 {
            weatherItems = weather.hourly
        } else {
            weatherItems = weather.daily
        }
    }
    
    var cities: [City]! = [City.Dnipro, City.Dubai, City.Kanberra, City.Kiev, City.London, City.Lviv, City.NewYork, City.Odessa]
    var choosedCity: City! = City.Dnipro {
        didSet {
            getWeatherAt(city: choosedCity)
        }
    }
    
    var a = [3,4,2,4,6.2,5,2.6,34,6,4,2,1]
    var weatherItems: [WeatherItem] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.setupChart()
            }
        }
    }
    
    var weather: Weather! {
        didSet {
            if self.weatherTypeSegmentedControl.selectedSegmentIndex == 0 {
                self.weatherItems = weather.hourly
            } else {
                self.weatherItems = weather.daily
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
        
        getWeatherAt(city: choosedCity)
    }
    
    func getWeatherAt(city: City) {
        SVProgressHUD.show()
        WeatherAPI.getWeatherFor(city: City.Dnipro) { [unowned self] (weather, error) in
            if let weather = weather {
                SVProgressHUD.dismiss()
                self.weather = weather
            } else if let error = error {
                SVProgressHUD.show(withStatus: error)
            }
        }
    }
    
    func setupChart() {
        var lineChartEntry = [ChartDataEntry]()
        for i in 0..<weatherItems.count {
            let value = ChartDataEntry(x: Double(i), y: weatherItems[i].temperature)
            lineChartEntry.append(value)
        }
        let line1 = LineChartDataSet(values: lineChartEntry, label: nil)
        line1.colors = [UIColor.blue]
        line1.drawCirclesEnabled = false
        line1.mode = .cubicBezier
        
        let data = LineChartData()
        data.addDataSet(line1)
        
        let xAxix = weatherChartView.xAxis
        xAxix.drawGridLinesEnabled = false
        xAxix.labelPosition = .bottom
        
        let leftYAxix = weatherChartView.getAxis(.left)
        leftYAxix.drawGridLinesEnabled = false
        
        weatherChartView.data = data
        weatherChartView.chartDescription?.text = "Weather Chart"
        weatherChartView.setScaleEnabled(false)
        weatherChartView.dragEnabled = false
        weatherChartView.pinchZoomEnabled = false
        weatherChartView.getAxis(.right).enabled = false
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String( cities[row].name )
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choosedCity = cities[row]
    }
    
}

