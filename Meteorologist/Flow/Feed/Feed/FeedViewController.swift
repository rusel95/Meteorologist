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


class FeedViewController: UIViewController {

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
    
    private var cities: [City]! = [City.Dnipro, City.Dubai, City.Kanberra, City.Kiev, City.London, City.Lviv, City.NewYork, City.Odessa]
    private var choosedCity: City! = City.Dnipro {
        didSet {
            getWeatherAt(city: choosedCity)
        }
    }
    
    private var currentItemType = WeatherItemType.hourly
    
    private var weather: Weather! = Weather() {
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
    
    private func getWeatherAt(city: City) {
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

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
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
            cell.initWith(weatherItem: weather.hourly[indexPath.row])
        case .daily:
            cell.initWith(weatherItem: weather.daily[indexPath.row])
        }
        return cell
    }
}

extension FeedViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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

extension FeedViewController {
    fileprivate func setupChartWith(hourlyItems: [HourlyItem]) {
        var lineChartEntry = [ChartDataEntry]()
        for i in 0..<hourlyItems.count {
            let value = ChartDataEntry(x: Double(i), y: hourlyItems[i].temperature)
            lineChartEntry.append(value)
        }
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Middle temperature")
        line1.colors = [UIColor.green]
        line1.drawCirclesEnabled = false
        line1.mode = .cubicBezier
        
        let data = LineChartData()
        data.addDataSet(line1)
        
        setVisualisationOptionsWith(data: data)
    }
    
    func setupChartWith(dailyItems: [DailyItem]) {
        var lineChartEntryHigh = [ChartDataEntry]()
        var lineChartEntryLow = [ChartDataEntry]()
        for i in 0..<dailyItems.count {
            lineChartEntryLow.append(ChartDataEntry(x: Double(i), y: dailyItems[i].temperatureLow))
            lineChartEntryHigh.append(ChartDataEntry(x: Double(i), y: dailyItems[i].temperatureHigh))
        }
        let lineHigh = LineChartDataSet(values: lineChartEntryHigh, label: "Highest")
        lineHigh.colors = [UIColor.red]
        lineHigh.drawCirclesEnabled = false
        lineHigh.mode = .cubicBezier
        
        let lineLow = LineChartDataSet(values: lineChartEntryLow, label: "Lowest")
        lineLow.colors = [UIColor.blue]
        lineLow.drawCirclesEnabled = false
        lineLow.mode = .cubicBezier
        
        let data = LineChartData()
        data.addDataSet(lineHigh)
        data.addDataSet(lineLow)
        
        setVisualisationOptionsWith(data: data)
    }
    
    private func setVisualisationOptionsWith(data: ChartData) {
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
        weatherChartView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7)
    }
}

extension FeedViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        tableView.scrollToRow(at: IndexPath(row: Int(entry.x), section: 0), at: .middle, animated: true)
    }
}
