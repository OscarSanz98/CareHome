//
//  PatientQoLCompareViewController.swift
//  CareHome
//
//  Created by Oscar on 31/03/2020.
//  Copyright © 2020 OscarSanz. All rights reserved.
//

import UIKit
import Firebase
//class for handling the patient qol compare interface - the comparison of individual scores of patients.
class PatientQoLCompareViewController: UIViewController {
//    initialise variables
    var patients: [String] = []
    var db = Firestore.firestore()
    var selectedPatients: [String:[Double]] = [:]
    
    
    var limit = 3
//    initalise the table on the interface
    @IBOutlet weak var patientTable: UITableView!
    
//when screen loaded, display all the patients in the same care home as the user, for selection.
    override func viewDidLoad() {
        super.viewDidLoad()
        //DatabaseManager.instance.getUserDetails()
        patientTable.allowsMultipleSelection = true
        
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
                            self.patientTable.reloadData()
                        }
                        
                    }
                }
            }
        }
        
    }
//    direct the user to the screen that shows the graph for comparison of patients.
    @IBAction func comparePatients(_ sender: Any) {
        
        self.performSegue(withIdentifier: "showResultsIndPatients", sender: self)
        
        
    }
//    sends data over to the next screen. Sends a dictionary of arrays - arrays of QoL scores.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "showResultsIndPatients") {
            let vc = segue.destination as! ResultsIndPatientQoLScoresViewController
                   
            vc.selectedPatients = self.selectedPatients
        }
       
        
        
    }
    
    
}

//handles the table in the interface.
extension PatientQoLCompareViewController: UITableViewDelegate, UITableViewDataSource {
    
//    sets the number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.patients.count
    }
//    sets the value for each row in the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "indPatientCell")
        
        
        cell.textLabel?.text = self.patients[indexPath.row]
        
        return cell
    }
    
//    calls addScores when user selects a patient on the table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let indexPath = tableView.indexPathForSelectedRow
        addScores()
    }
//    calls removeScores function with the cell that was deselected from the table.
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        removeScores(cell: cell)
        tableView.deselectRow(at: indexPath, animated: false)
    }
//    sets the limit for the number of rows in the table that can be selected.
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let selectedRows = tableView.indexPathsForSelectedRows?.filter({ $0.section == indexPath.section }) {
            if selectedRows.count == limit {
                return nil
            }
        }

        return indexPath
    }
//    removes the QoL scores from the array selectedPatients.
    func removeScores(cell: UITableViewCell) {
        if self.selectedPatients[cell.textLabel!.text!] != nil {
            self.selectedPatients.removeValue(forKey: cell.textLabel!.text!)
            
            print(self.selectedPatients)
        }
    }
//    retrieves all scores for that recently selected patient on the table. Stores the scores into the dictionary
    func addScores(){
        if let arr = self.patientTable.indexPathsForSelectedRows {
            for index in arr {
                let exists = self.selectedPatients[self.patients[index.row]] != nil
                       
                if exists == false {
                    db.collection("QoLScores").whereField("PatientName", isEqualTo: self.patients[index.row]).getDocuments(){ (snapshot, err) in
                                   
                        if let err = err {
                            print(err)
                        } else {
                            var arr: [Double] = []
                            
                            for doc in snapshot!.documents {
                                arr.append(doc.get("QoLScore") as! Double)
                                          
                            }
                            self.selectedPatients[self.patients[index.row]] = arr
                            
                        }
                    }
                    
                    
                }
                
            }
            
        }
    }
    
}

