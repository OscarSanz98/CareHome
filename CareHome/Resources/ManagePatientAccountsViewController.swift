//
//  ManagePatientAccountsViewController.swift
//  CareHome
//
//  Created by Oscar on 20/05/2020.
//  Copyright © 2020 OscarSanz. All rights reserved.
//

import UIKit
import Firebase
//this class handles the interface for managing patient accounts stored on the central database.
class ManagePatientAccountsViewController: UIViewController {
//    initialise variables
    var db = Firestore.firestore()
    var user = Auth.auth().currentUser?.uid
    var homeID = 0
    var patients = [String]()
    var cell = UITableViewCell()
    
//initialise objects on the interface
    @IBOutlet weak var patientTable: UITableView!
    @IBOutlet weak var editAccountBtn: UIButton!
    @IBOutlet weak var deleteAccountBtn: UIButton!
    
//    when the screen is loading in it displays all the patients in the same care home as the user in the table.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editAccountBtn.isEnabled = false
        
        db.collection("CareStaff").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print(err)
            } else {
                for doc in querySnapshot!.documents {
                    let uid = doc.get("user_id") as! String
                    var homeCareID = 0
                    if uid == self.user! {
                        //print("yay")
                        homeCareID = doc.get("HomeCareID") as! Int
                        self.homeID = homeCareID
                        self.db.collection("Patients").getDocuments(){
                            (query, error) in
                            if let err = error {
                                print(err)
                            } else {
                                for d in query!.documents {
                                    if d.get("HomeCareID") as! Int == homeCareID {
                                        self.patients.append(d.get("FullName") as! String)
                                        
                                    }
                                }
                                self.patientTable.reloadData()
                            }
                        }
                    }
                }
            }
        }

        // Do any additional setup after loading the view.
    }
//    when user selects edit account button it directs the user to the edit patient account screen.
    @IBAction func editAccountPressed(_ sender: Any) {
        performSegue(withIdentifier: "editAccountSegue", sender: self)
    }
//    when user selects the delete button it deletes the selected patient account from the firestore.It then displays a popup if successful, and updates the table displaying all patients in the same care home.
    @IBAction func deleteAccountPressed(_ sender: Any) {
        
        db.collection("Patients").whereField("FullName", isEqualTo: self.cell.textLabel!.text!).getDocuments(){ (snapshot, err) in
            
            if let err = err {
                print(err)
            } else {
                for doc in snapshot!.documents {
                    let patientDocID = doc.documentID
                    self.db.collection("Patients").document(patientDocID).delete() { error in
                        if let error = error {
                            print(error)
                        } else {
                            self.db.collection("QoLScores").whereField("PatientName", isEqualTo: self.cell.textLabel!.text!).getDocuments(){ (snap, err) in
                                
                                if let er = err {
                                    print(er)
                                } else {
                                    for doc in snap!.documents{
                                        let docID = doc.documentID
                                        self.db.collection("QoLScores").document(docID).delete(){ er in
                                            if let er = er {
                                                print(er)
                                            } else {
                                                print("success")
                                                self.patientTable.reloadData()
                                            }
                                            
                                        }
                                        
                                    }
                                }
                                
                            }
                            
                        }
                        
                    }
                }
                let alertController = UIAlertController(title: "Success", message:
                    "The account was successfully deleted.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

                self.present(alertController, animated: true, completion: nil)
                self.patientTable.reloadData()
                self.patientTable.reloadInputViews()
                
            }
            
        }
    }
    
//    sends data to the edit account screen - sends the selected patient for editing.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editAccountSegue") {
            let vc = segue.destination as! EditPatientAccountViewController
            vc.patientSelected = self.cell.textLabel!.text!
        }
    }

    
}
//this extension handles the table in the interface
extension ManagePatientAccountsViewController:UITableViewDelegate, UITableViewDataSource {
//    sets the number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patients.count
    }
//    sets the value for each row in the table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "PatientCell")
        
        
        cell.textLabel?.text = patients[indexPath.row]
        
        return cell
        
    }
//    when user selects a row it enables the buttons on the screen, to perform an operation on the account.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow
        self.cell = tableView.cellForRow(at: indexPath!)!
        self.editAccountBtn.isEnabled = true
        self.deleteAccountBtn.isEnabled = true
    }
//    when a user deselects a row on the table it disables the buttons on the page, so a user can't try to perform an operation without selecting an account.
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.editAccountBtn.isEnabled = false
        self.deleteAccountBtn.isEnabled = false
    }
    
    
    

}
