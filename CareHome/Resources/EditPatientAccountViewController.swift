//
//  EditPatientAccountViewController.swift
//  CareHome
//
//  Created by Oscar on 20/05/2020.
//  Copyright © 2020 OscarSanz. All rights reserved.
//

import UIKit
import Firebase
//this class handles the interface for editing a patient account on the database.
class EditPatientAccountViewController: UIViewController {
    //initialise variables
    var db = Firestore.firestore()
    var user = Auth.auth().currentUser?.uid
    var patientSelected = ""
    
//    initialise objects on the interface.
    @IBOutlet weak var patientNameTxtField: UITextField!
    @IBOutlet weak var dateofBirthTxt: UITextField!
    @IBOutlet weak var editAccountBtn: UIButton!
//    when the screen is loading in, it retrieves the current account details for the selected patient and displays the info in the relevant fields to the user.
    override func viewDidLoad() {
        super.viewDidLoad()

        db.collection("Patients").whereField("FullName", isEqualTo: patientSelected).getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print(err)
            } else {
                for doc in querySnapshot!.documents {
                    self.patientNameTxtField.text = doc.get("FullName") as? String
                    self.dateofBirthTxt.text = doc.get("DateOfBirth") as? String
                }
            }
            
        }
        // Do any additional setup after loading the view.
    }
//when user selects the date of birth text field, it brings up a date picker.
    @IBAction func dateOfBirthEditor(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(EditPatientAccountViewController.datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
    }
    
//    handles the date picker field - ensures that it is in the right date format.
    @objc func datePickerValueChanged(_ sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateofBirthTxt.text = dateFormatter.string(from: sender.date)
        
    }
//    when user clicks the edit account button, it performs checks to see if the text fields have valid values, and then updates the patient's account details in Firestore to the values stated in the text fields. If successful it displays a popup to the user saying so.If not, an error will be shown.
    @IBAction func editAccountPressed(_ sender: Any) {
        //patientNameTxt.text!.isEmpty || dateOfBirthTxt.text!.isEmpty
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        
        if patientNameTxtField.text!.isBlank == true{
            alert(patientNameTxtField)
        } else if dateofBirthTxt.text!.isBlank == true {
            alert(dateofBirthTxt)
        }else if dateFormatter.date(from: dateofBirthTxt.text!) == nil{
            alert(dateofBirthTxt)
        }else {
            db.collection("Patients").whereField("FullName", isEqualTo: self.patientSelected).getDocuments(){ (snapshot,err)in
                
                if let err = err {
                    print(err)
                } else {
                    for doc in snapshot!.documents {
                        let documentID = doc.documentID
                        self.db.collection("Patients").document(documentID).updateData([
                            "FullName" : self.patientNameTxtField.text!,
                            "DateOfBirth" : self.dateofBirthTxt.text!]) { er in
                                if let error = er {
                                    print(error)
                                    let alertController = UIAlertController(title: "Error", message:
                                        "Sorry we couldn't edit the patient's account, please try again.", preferredStyle: .alert)
                                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

                                    self.present(alertController, animated: true, completion: nil)
                                } else {
                                    self.db.collection("QoLScores").whereField("PatientName", isEqualTo: self.patientSelected).getDocuments(){ (snap, err) in
                                        if let err = err {
                                            print(err)
                                            let alertController = UIAlertController(title: "Error", message:
                                                "Sorry we couldn't edit the patient's account, please try again.", preferredStyle: .alert)
                                            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

                                            self.present(alertController, animated: true, completion: nil)
                                        } else {
                                            for document in snap!.documents {
                                                let docID = document.documentID
                                                self.db.collection("QoLScores").document(docID).updateData(["PatientName": self.patientNameTxtField.text!]) {
                                                    error in
                                                    if let er = error {
                                                        print(er)
                                                        let alertController = UIAlertController(title: "Error", message:
                                                            "Sorry we couldn't edit the patient's account, please try again.", preferredStyle: .alert)
                                                        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

                                                        self.present(alertController, animated: true, completion: nil)
                                                    } else {
                                                        let alertController = UIAlertController(title: "Success", message:
                                                            "The account was successfully updated.", preferredStyle: .alert)
                                                        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

                                                        self.present(alertController, animated: true, completion: nil)
                                                        self.performSegue(withIdentifier: "editedAccount", sender: nil)
                                                    }
                                                }
                                            }
                                        }
                                        
                                    }
                                }
                        }
                    }
                }
                
            }
            
        }
    }
//    alerts the user that the value they entered in the textfield sent to this function was invalid.
    func alert(_ sender: UITextField){
        if sender == patientNameTxtField {
            patientNameTxtField.text = ""
            sender.attributedPlaceholder = NSAttributedString(string: "name invalid", attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
        } else {
            dateofBirthTxt.text = ""
            sender.attributedPlaceholder = NSAttributedString(string: "date of birth invalid", attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
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



