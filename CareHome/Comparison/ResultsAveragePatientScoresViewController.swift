//
//  ResultsAveragePatientScoresViewController.swift
//  CareHome
//
//  Created by Oscar on 05/04/2020.
//  Copyright © 2020 OscarSanz. All rights reserved.
//

import UIKit
import Charts
//this class is used for handling the interface of displaying the average qol scores commparison for patients in a chart view.
class ResultsAveragePatientScoresViewController: UIViewController {
//initialises the variables
    var averageScores: [String: Double] = [:]
    var scores: [Double] = []
    var patientNames: [String] = []
//    initialise the bar chart view on the interface
    @IBOutlet weak var barChartView: BarChartView!
//    upon loading the screen call customiseChart function to plot the average qol scores onto the bar chart and display it.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (key,val) in averageScores {
            patientNames.append(key)
            scores.append(val)
        }
        
        customiseChart(dataPoints: patientNames, values: scores)

        // Do any additional setup after loading the view.
    }
    
//plot the average qol scores, passed to the parameter values, on the bar chart, and assign each bar a different colour by calling generateRandomColor(). Then display the plotted bar chart to the user.
    func customiseChart(dataPoints: [String], values: [Double]) {
        let chartData = BarChartData()
        
           
        for i in 0..<dataPoints.count {
            var dataEntries: [BarChartDataEntry] = []
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            
            dataEntries.append(dataEntry)
            let chartDataSet = BarChartDataSet(entries: dataEntries, label: dataPoints[i])
            chartDataSet.setColor(generateRandomColor())
            chartData.addDataSet(chartDataSet)
        }
           
           
        //let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
           
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        barChartView.sizeToFit()
        barChartView.xAxis.granularity = 1
        barChartView.backgroundColor = UIColor.white
           
        //chartView.reloadInputViews()
    }
//generate a random colour and then return it.
    func generateRandomColor() -> UIColor {
      let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
      let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
      let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
            
      return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}
