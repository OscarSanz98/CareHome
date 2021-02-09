//
//  SelectPatientViewController.swift
//  CareHome
//
//  Created by Oscar on 23/02/2020.
//  Copyright © 2020 OscarSanz. All rights reserved.
//

import UIKit
import Firebase
import ResearchKit
//class used to handle the interface for selecting a patient to complete the questionnaire on.
class SelectPatientViewController: UIViewController {
    
//    initialise variables
    var patients = [String]()
    var db = Firestore.firestore()
    var user = Auth.auth().currentUser?.uid
    var data = [String]()
    var cell = UITableViewCell()
    var homeID = 0
    var patientName = ""
    var finishedQuest = false
//    initialise text fields and connect to the objects on the interface.
    @IBOutlet weak var patientTableView: UITableView!
    @IBOutlet weak var selectPatientBtn: UIButton!
    
//    when screen is loaded store a copy of the database data into cache
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        
        selectPatientBtn.isEnabled = false
      
       
        // Do any additional setup after loading the view.
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        
        
//        display all of the patients in the same care home as the user in a table
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
                                        print(self.patients)
                                    }
                                }
                                self.patientTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        //print("self.id is: ", self.id)
        
    }
    
    

//start the questionnaire when the user has selected a patient from the table and clicked the 'select patient' button.
    @IBAction func patientSelected(_ sender: Any) {
        print(self.cell.textLabel!.text!)
        self.patientName = self.cell.textLabel!.text!
        let taskViewController = ORKTaskViewController(task: SurveyQoL, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
      
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "finishedQ" {
//            let vc = segue.destination as! ChartViewController
//            vc.PatientName = self.patientName
//        }
//        
//    }

}
//handles the table in the interface
extension SelectPatientViewController:UITableViewDelegate, UITableViewDataSource {
    
//    sets the number of rows in the table based on the array patients
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patients.count
    }
    
//    displays each patient on an individual row in the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "PatientCell")
        
        
        cell.textLabel?.text = patients[indexPath.row]
        
        return cell
        
    }
    
//    when user selects a patient it highlights that selected row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow
        self.cell = tableView.cellForRow(at: indexPath!)!
        self.selectPatientBtn.isEnabled = true
    }
    
    
    

}


//This is used to carry out/start the Questionnaire - and what happens afterwards
//It also calculates the scores
extension SelectPatientViewController: ORKTaskViewControllerDelegate {
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
           
            var finalResult = 0
            var empty = [Int]()
            var startDate = Date()
            var endDate = Date()
            
            switch reason {
            case .completed:
                if let taskResults = taskViewController.result.results {
                    for stepResults in taskResults as! [ORKStepResult] {
                            
                            for result in stepResults.results! {
                                let value = result.identifier
                                print(value)
                                if (value != "IntroductionStep" &&
                                    value != "FirstSetOfQuestions" &&
                                    value != "SecondSetOfQuestions" &&
                                    value != "ThirdSetOfQuestions" &&
                                    value != "FourthSetOfQuestions" &&
                                    value != "SummaryStep" &&
                                    value != "SummaryStep2" &&
                                    value != "ConsentReviewStep" &&
                                    value != "VisualConsentStep" &&
                                    value != "ConsentDocumentParticipantSignature"){
                                    
                                    let num = result as! ORKQuestionResult
                                    let numberChosen = num.answer! as! NSArray
                                    empty.append(numberChosen[0] as! Int)
                                    
                                    
                                    finalResult = finalResult + empty[0]
                                    if(value == "FirstQuestion"){
                                        startDate = result.startDate
                                    }
                                    if(value == "32Question"){
                                        endDate = result.endDate
                                    }
                                    
                                }
                            }
                           
                        }
                        
                    }
                //HERE NOW SEND SCORE TO THE DATABASE
                DatabaseManager.instance.uploadQOLScore(staffID: self.user!, homecareID: self.homeID, patientName: self.cell.textLabel!.text!, qolScore: finalResult, endDate: endDate, startDate: startDate)
                
                print("Final value is: \(finalResult)")
                taskViewController.dismiss(animated: true, completion: nil)
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let pickupVC = storyboard.instantiateViewController(withIdentifier: "ResultsVC") as? ChartViewController
                pickupVC?.initData(patientName: self.patientName)
                present(pickupVC!, animated: true, completion: nil)
                       
              
                
            case .discarded:
                 taskViewController.dismiss(animated: true, completion: nil)
            
                
            default:
                print("Failed")
                let alertController = UIAlertController(title: "Error", message:
                    "Sorry we couldn't calculate the patient's QoL score, please try again.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

                self.present(alertController, animated: true, completion: nil)
                taskViewController.dismiss(animated: true, completion: nil)
            }
            
       
    }
    
//    present alert on the text field passed to this function
    func alert(_ sender: UITextField){
        sender.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
        
    }
    
    
  
}
