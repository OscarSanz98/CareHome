//
//  HistoryViewController.swift
//  CareHome
//
//  Created by Oscar on 27/04/2020.
//  Copyright © 2020 OscarSanz. All rights reserved.
//

import UIKit
import Firebase
//class used for handling the history interface in the application.
class HistoryViewController: UIViewController {
//initialise variables
    var db = Firestore.firestore()
    var user = Auth.auth().currentUser
    var completedQol: [String] = []
    var completedDates: [Date] = []
    var qolScores: [Int] = []
    var date = Timestamp()
//    initialise table in the interface
    @IBOutlet weak var historyChartView: UITableView!

    
//    when the screen is loading retrieve all the qol scores that were calculated by the user logged in, and display the score with the date it was calculated and the name of the patient the score correlates to.
    override func viewDidLoad() {
        super.viewDidLoad()

        db.collection("QoLScores").whereField("CareStaffID", isEqualTo: user!.uid).getDocuments(){ (querySnapshot, err) in

            if let err = err {
                print(err)
            } else {
                for doc in querySnapshot!.documents {
                    self.completedQol.append(doc.get("PatientName") as! String)

                    self.date = doc.get("endDate") as! Timestamp
                    self.completedDates.append(self.date.dateValue())
                    self.qolScores.append(doc.get("QoLScore") as! Int)
                }
            }
            self.historyChartView.reloadData()
        }
        
    }
    

    

}
//this extension class handles the table view
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
//    sets the number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.completedQol.count
    }
//    sets the value for each row in the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "historyCell")
        
        
        // Fetches the appropriate meal for the data source layout.
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        print(df.string(from: self.completedDates[indexPath.row]))
        let now = df.string(from: self.completedDates[indexPath.row])
        print(String(self.qolScores[indexPath.row]))
        
        cell.textLabel?.text = self.completedQol[indexPath.row] + " - Date:  " + now + "   -    QoL Score: " + String(self.qolScores[indexPath.row])
        
        return cell
    }
    
}
