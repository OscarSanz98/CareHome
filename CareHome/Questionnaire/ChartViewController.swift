//
//  ChartViewController.swift
//  CareHome
//
//  Created by Oscar on 21/03/2020.
//  Copyright © 2020 OscarSanz. All rights reserved.
//

import UIKit
import Charts
import Firebase
//class used to handle the interface for displaying the qol scores of a patient after the questionnaire has been completed.
class ChartViewController: UIViewController {
//    initialise variables
    var PatientName = ""
    var db = Firestore.firestore()

//    initialise text fields on interface
    @IBOutlet weak var viewControllerTitle: UILabel!
    
    @IBOutlet weak var lineChartView: LineChartView!
    
//    when screen is loaded it gets all of the quality of life scores of the patient, stored on the firestore, and stores the scores and dates into arrays.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllerTitle.text = self.PatientName
        //self.PatientName = "Spicy"
        
        db.collection("QoLScores").whereField("PatientName", isEqualTo: self.PatientName).getDocuments(){ (querySnapshot, err) in

            if let err = err {
                print(err)
            } else {

                var h = [Double]()
                var dates = [String]()

                for snap in querySnapshot!.documents {
                    h.append(snap.get("QoLScore") as! Double)
                    let timeStampVal = (snap.get("endDate") as! Timestamp)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    let stringDate = formatter.string(from: timeStampVal.dateValue())
                    dates.append(stringDate)
                }
//                once the scores and dates have been retrieved call customizeChart function to display the chart.
                self.customizeChart(dataPoints: dates, values: h.map({Double($0)}))

            }

        }
       

        // Do any additional setup after loading the view.
    }
//    sets the value of PatientName to the value passed in the parameters
    func initData(patientName: String){
        self.PatientName = patientName
    }
//    creates the line chart graph using the Charts API. Plots the QoL scores passed in the parameters of the function and labels each score with the date it was calculated on.
    func customizeChart(dataPoints: [String], values: [Double]) {
      
        var dataEntries: [ChartDataEntry] = []
      
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Quality of Life Score")
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        
        lineChartView.data = lineChartData
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        lineChartView.sizeToFit()
        lineChartView.xAxis.granularity = 1
        lineChartView.backgroundColor = UIColor.white
    }


}
