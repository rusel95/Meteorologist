//
//  MyChart.swift
//  Meteorologist
//
//  Created by Ruslan Popesku on 4/4/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Foundation
import UIKit
import Charts

extension MainVC {
    func setupChartWith(hourlyItems: [HourlyItem]) {
        var lineChartEntry = [ChartDataEntry]()
        for i in 0..<hourlyItems.count {
            let value = ChartDataEntry(x: Double(i), y: hourlyItems[i].temperature)
            lineChartEntry.append(value)
        }
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Middle temp")
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
        weatherChartView.backgroundColor = UIColor.white
    }

}
