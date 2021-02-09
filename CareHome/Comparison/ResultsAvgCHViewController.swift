//
//  ResultsAvgCHViewController.swift
//  CareHome
//
//  Created by Oscar on 31/03/2020.
//  Copyright © 2020 OscarSanz. All rights reserved.
//

import UIKit
import Charts
import Firebase
//class used to handle the page for displaying the average quality of life scores for care homes.
class ResultsAvgCHViewController: UIViewController {
//    initialise variables
    var careHomes: [String] = []
    var scores: [Double] = []
    var db = Firestore.firestore()
    var currentID = 0
    var averageScores: [String:Double] = [:]
//initalise the bar chart view to display the QoL scores
    @IBOutlet weak var chartView: BarChartView!
    
//    call customiseChart function to plot the QoL scores on the graph, when the screen is loaded into.
    override func viewDidLoad() {
        super.viewDidLoad()
        print(averageScores)
        for (key,val) in averageScores {
            careHomes.append(key)
            scores.append(val)
        }
        
        customiseChart(dataPoints: careHomes, values: scores)
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
    
    }
    
 
    
//    plot the quality of life scores, sent in the parameter, on the bar chart view. Give each care home a different colour and add a label to each bar to show which care home it belongs to.
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
        chartView.data = chartData
           
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        chartView.sizeToFit()
        chartView.xAxis.granularity = 1
        chartView.backgroundColor = UIColor.white
           
        //chartView.reloadInputViews()
    }
//generates a random colour and returns that colour
    func generateRandomColor() -> UIColor {
      let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
      let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
      let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
            
      return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    


}
