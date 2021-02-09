//
//  AveragePatientQoLScoreViewController.swift
//  CareHome
//
//  Created by Oscar on 05/04/2020.
//  Copyright © 2020 OscarSanz. All rights reserved.
//

import UIKit
import Firebase
//class used to handle the interface for choosing patients for the average patient qol score comparison.
class AveragePatientQoLScoreViewController: UIViewController {
//initialise the table view
    @IBOutlet weak var patientTble: UITableView!
//    initialise the variables
    var db = Firestore.firestore()
    var averageScores : [String: Double] = [:]
    var patients : [String] = []
    
//    display all the patients in the same care home as the user
    override func viewDidLoad() {
        super.viewDidLoad()
        
        patientTble.allowsMultipleSelection = true

        db.collection("CareStaff").whereField("user_id", isEqualTo: Auth.auth().currentUser!.uid).getDocuments(){ (snapshot, err) in
            
            if let err = err {
                print(err)
            } else {
                
                for doc in snapshot!.documents {
                    let id = doc.get("HomeCareID")
                    
                    self.db.collection("Patients").whereField("HomeCareID", isEqualTo: id!).getDocuments(){ (querySnapshot, er) in
                        if let err = er {
                            print(err)
                        } else {
                            for document in querySnapshot!.documents {
                                self.patients.append(document.get("FullName") as! String)
                            }
                            self.patientTble.reloadData()
                        }
                        
                    }
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
//    direct uesr to the screen which displays the average qol scores when the compare button has been pressed, and patients have been selected.
    @IBAction func comparisonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "showResultsAvgPatient", sender: self)
    }
//    sends data to the next screen - sends the calculated average quality of life scores for each selected patient.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showResultsAvgPatient") {
            let vc = segue.destination as! ResultsAveragePatientScoresViewController
            vc.averageScores = self.averageScores
        }
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//handles the view of the table on the interface.
extension AveragePatientQoLScoreViewController: UITableViewDelegate, UITableViewDataSource {
//    sets the number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        patients.count
    }
//    sets the value for each row in the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "avgPatientCell")
               
               
        cell.textLabel?.text = self.patients[indexPath.row]
               
        return cell
    }
//    calls addAvgScore when a user selects a row in the table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         addAvgScore()
    }
//    calls removeAvgScore with the cell that was deselected from the table
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        removeAvgScore(cell: cell)
        tableView.deselectRow(at: indexPath, animated: false)
    }
//    removes the average score from the dictionary using the value of the cell.
    func removeAvgScore(cell: UITableViewCell){
        if self.averageScores[cell.textLabel!.text!] != nil {
            self.averageScores.removeValue(forKey: cell.textLabel!.text!)
            print(self.averageScores)
        }
    }
//    calculates the average quality of life score for each selected patient in the table, and stores it in the dictionary.
    func addAvgScore(){
        if let arr = self.patientTble.indexPathsForSelectedRows {
            for index in arr {
                let exists = self.averageScores[self.patients[index.row]] != nil
            
                if exists == false {
                    db.collection("QoLScores").whereField("PatientName", isEqualTo: self.patients[index.row]).getDocuments(){ (querySnapshot, err) in
                        if let err = err {
                            print(err)
                        } else {
                            var avg = 0
                            for doc in querySnapshot!.documents {
                                avg += doc.get("QoLScore") as! Int
                                
                            }
                            
                            avg = avg / querySnapshot!.documents.count
                            self.averageScores[self.patients[index.row]] = Double(avg)
                            
                        }
                        
                    }
                }
            }
        }
    }
    
    
}
