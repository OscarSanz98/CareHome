//
//  ResultsIndPatientQoLScoresViewController.swift
//  CareHome
//
//  Created by Oscar on 05/04/2020.
//  Copyright © 2020 OscarSanz. All rights reserved.
//

import UIKit
import Charts
import Firebase
//class used for handling the graph screen interface - the graph displays all quality of life scores of up to 3 patients.
class ResultsIndPatientQoLScoresViewController: UIViewController {
//initialise variables
    var selectedPatients: [String: [Double]] = [:]
    var patientNames: [String] = []
    
    var set1 : [Double] = []
    
    var set2 : [Double] = []
    
    var set3: [Double] = []
    
    
    var db = Firestore.firestore()
//    initialise the line chart view on the interface.
    @IBOutlet weak var chartView: LineChartView!
    
//    calls customizeChart with data dependent on the number of selected patients for the comparison.
    override func viewDidLoad() {
        super.viewDidLoad()

        print(self.selectedPatients)
           
        for (key, _) in self.selectedPatients{
            patientNames.append(key)
        }

        switch self.selectedPatients.count {
        case 1:
            
            set1.append(contentsOf: selectedPatients[patientNames[0]]!)
            customizeChart(values1: set1, values2: set2, values3: set3, names: patientNames)
            
            break

        case 2:
            set1.append(contentsOf: selectedPatients[patientNames[0]]!)
            set2.append(contentsOf: selectedPatients[patientNames[1]]!)
            customizeChart(values1: set1, values2: set2, values3: set3, names: patientNames)
            break

        case 3:
            set1.append(contentsOf: selectedPatients[patientNames[0]]!)
            set2.append(contentsOf: selectedPatients[patientNames[1]]!)
            set3.append(contentsOf: selectedPatients[patientNames[2]]!)
            customizeChart(values1: set1, values2: set2, values3: set3, names: patientNames)
            break

        default:
            break
        }
    

    }
    

    // this function creates a line chart and plots data dependent on how many patients were seleced. Displays this line chart to the user through the chart view initialised at the top of the class.
    func customizeChart(values1: [Double], values2: [Double], values3: [Double], names: [String]) {
        
        let data = LineChartData()
        var lineChartEntry1 = [ChartDataEntry]()

        for i in 0..<values1.count {
            lineChartEntry1.append(ChartDataEntry(x: Double(i), y: Double(values1[i])))
        }
        let line1 = LineChartDataSet(entries: lineChartEntry1, label: names[0])
        line1.setColor(UIColor(red: 104/255, green: 241/255, blue: 175/255, alpha: 1))
        line1.setCircleColor(UIColor(red: 104/255, green: 241/255, blue: 175/255, alpha: 1))
        data.addDataSet(line1)
        
        if (values2.count > 0) {
            var lineChartEntry2 = [ChartDataEntry]()
            for i in 0..<values2.count {
                lineChartEntry2.append(ChartDataEntry(x: Double(i), y: Double(values2[i]) ))
            }
            let line2 = LineChartDataSet(entries: lineChartEntry2, label: names[1])
            line2.setColor(UIColor(red: 164/255, green: 228/255, blue: 251/255, alpha: 1))
            line2.setCircleColor(UIColor(red: 164/255, green: 228/255, blue: 251/255, alpha: 1))
            data.addDataSet(line2)
            
        }
        
        if (values3.count > 0) {
            var lineChartEntry3 = [ChartDataEntry]()
            for i in 0..<values3.count {
                lineChartEntry3.append(ChartDataEntry(x: Double(i), y: Double(values3[i]) ))
            }
            let line3 = LineChartDataSet(entries: lineChartEntry3, label: names[2])
            line3.setColor(UIColor(red: 242/255, green: 247/255, blue: 158/255, alpha: 1))
            line3.setCircleColor(UIColor(red: 242/255, green: 247/255, blue: 158/255, alpha: 1))
            data.addDataSet(line3)
        }
        
        self.chartView.data = data
        self.chartView.xAxis.enabled = false
        self.chartView.sizeToFit()
        self.chartView.backgroundColor = UIColor.white
        
    }
    
    
    

}
