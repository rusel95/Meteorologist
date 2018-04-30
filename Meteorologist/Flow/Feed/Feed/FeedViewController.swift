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

protocol FeedViewControllerOutput: FeedModelInput {}
protocol FeedViewControllerInput: FeedModelOutput {}

class FeedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityPickerView: UIPickerView!
    @IBOutlet weak var weatherTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var weatherChartView: LineChartView!
    
    @IBAction func weatherTypeChanged(_ sender: UISegmentedControl) {
        model.changeWeatherType(to: sender.selectedSegmentIndex)
        tableView.reloadData()
    }
    
    var model: FeedViewControllerOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        cityPickerView.delegate = self
        cityPickerView.dataSource = self
        weatherChartView.delegate = self
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.perform(action: .viewAppeared)
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.registerReusableCell(cellType: WeatherItemCell.self)
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath, cellType: WeatherItemCell.self)
        cell.initWith(weatherItem: model.feedSectionData(at: indexPath.row))
        return cell
    }
}

extension FeedViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return model.getNumberOfCities()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return model.getCityNameAt(row: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        model.setChoosedCityTo(row: row)
    }
}

extension FeedViewController: FeedViewControllerInput {
    func didStartActivity(_ activity: FeedModel.Activity) {
        SVProgressHUD.show()
    }
    
    func didFinishActivity(_ activity: FeedModel.Activity) {
        SVProgressHUD.dismiss {
            self.tableView.reloadData()
        }
    }
    
    func didFinishActivity(_ activity: FeedModel.Activity, with error: String) {
        SVProgressHUD.showError(withStatus: error)
    }
    
    internal func setupChartWith(hourlyItems: [HourlyItem]) {
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
    
}

extension FeedViewController {
    
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
