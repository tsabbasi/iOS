//
//  BarChartViewController.swift
//  iOSChartsDemo
//
//  Created by Joyce Echessa on 6/12/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import Charts

class BarChartViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var barChartView: BarChartView!
    @IBAction func saveChart(sender: AnyObject) {
        
        barChartView.saveToCameraRoll()
        
    }
    
    
    var months : [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        barChartView.delegate = self
        
        barChartView.noDataText = "You need to provide data for the chart."
        barChartView.noDataTextDescription = "DESCRIPTION"
        
        
        months = ["Your Offset", "Race Individual Emission"]
        let carbonEmission = [4.0, 10]
        
        setChart(months, values: carbonEmission)
        
    }
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries : [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
            
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Carbon Emission and Offset")
        let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
        barChartView.data = chartData
        
        barChartView.descriptionText = ""
        
        
        /*
        Pass in a array of color objects equal to the data Entries, if provided less color objects than the number of dataentries then the scheme will be repeated.
        */
        chartDataSet.colors = [UIColor(red: 0/255, green: 100/255, blue: 0/255, alpha: 1),
            UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)]
        
        // Predefined color templates
//        ChartColorTemplates.liberty()
//        ChartColorTemplates.joyful()
//        ChartColorTemplates.pastel()
//        ChartColorTemplates.colorful()
//        ChartColorTemplates.vordiplom()
        
//        chartDataSet.colors = ChartColorTemplates.vordiplom()
        
        barChartView.xAxis.labelPosition = .Bottom
//        barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        
//        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
        
        let limitLine = ChartLimitLine(limit: 10.0, label: "Your Offset Target")
        barChartView.rightAxis.addLimitLine(limitLine)
        
        
    }
    
    
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print("\(entry.value) in \(months[entry.xIndex])")
    }


}

