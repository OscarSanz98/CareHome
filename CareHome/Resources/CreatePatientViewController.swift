//
//  CreatePatientViewController.swift
//  CareHome
//
//  Created by Oscar on 23/02/2020.
//  Copyright © 2020 OscarSanz. All rights reserved.
//

import UIKit
// class used to handle the interface for creating a patient on the central database
class CreatePatientViewController: UIViewController {
//initialise text fields and connect the code to the object on the interface.
    @IBOutlet weak var patientNameTxt: UITextField!
    
    @IBOutlet weak var dateOfBirthTxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
//    sets the age text field to display a date picker when user clicks on it.
    @IBAction func ageEditing(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
               
        datePickerView.datePickerMode = UIDatePicker.Mode.date
               
        sender.inputView = datePickerView
        
               
               
        //datePickerView.maximumDate = (Calendar.current as NSCalendar).date(byAdding: .year, value: -10, to: Date(), options: [])
               
        datePickerView.addTarget(self, action: #selector(CreatePatientViewController.datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
    }
    
    
    //this function checks whether the date picker has been updated
    @objc func datePickerValueChanged(_ sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateOfBirthTxt.text = dateFormatter.string(from: sender.date)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
//    hides the keyboard when the user clicks off the textfields
    @IBAction func editingPressed(_ sender: Any) {
        self.view.endEditing(true)
    }
    
//    function used to create a patient on the cloud firestore when the user clicks the create patient button.
    @IBAction func createPatientPressed(_ sender: Any) {
        //patientNameTxt.text!.isEmpty || dateOfBirthTxt.text!.isEmpty
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        
        if patientNameTxt.text!.isBlank == true{
            alert(patientNameTxt)
        } else if dateOfBirthTxt.text!.isBlank == true {
            alert(dateOfBirthTxt)
        }else if dateFormatter.date(from: dateOfBirthTxt.text!) == nil{
            alert(dateOfBirthTxt)
        }else {
            DatabaseManager.instance.createPatient(name: patientNameTxt.text!, dateOfBirth: dateOfBirthTxt.text!)
            performSegue(withIdentifier: "patientCreated", sender: nil)
            //performSegue(withIdentifier: "patientCreated", sender: nil)
        }
        
        
    }
    
//    presents an alert on the textfield passed to this function.
    func alert(_ sender: UITextField){
        if sender == patientNameTxt {
            patientNameTxt.text = ""
            sender.attributedPlaceholder = NSAttributedString(string: "name invalid", attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
        } else {
            dateOfBirthTxt.text = ""
            sender.attributedPlaceholder = NSAttributedString(string: "date of birth invalid", attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
        }
        
              
    }
       
    

}

//function used to check if the string passed to it is blank.
//this includes tab space, normal space.
//returns a boolean value of true or false on whether the string is blank or not.
extension String {
    var isBlank: Bool {
        return allSatisfy({ $0.isWhitespace })
    }
}
