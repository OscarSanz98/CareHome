//
//  ChangeEmailViewController.swift
//  CareHome
//
//  Created by Oscar on 29/01/2020.
//  Copyright © 2020 OscarSanz. All rights reserved.
//

import UIKit
import Firebase
//class used to handle interface for the change email page.
class ChangeEmailViewController: UIViewController {
//initialise text fields and are connected to the front-end interface
    @IBOutlet weak var newEmailTxt: UITextField!
    @IBOutlet weak var confirmEmailTxt: UITextField!
    
    @IBOutlet weak var updateEmailBtn: UIButton!
    
// initialise variables
    var db = Firestore.firestore()
    var success = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
//    updateEmail carried out when user clicks the update email button.
//    It calls the function updateEmailAddress in DatabaseManager.
    @IBAction func updateEmail(_ sender: Any) {
        
        if newEmailTxt.text!.isEmpty || confirmEmailTxt.text!.isEmpty {
            alert(newEmailTxt)
            alert(confirmEmailTxt)
        } else {
            self.view.endEditing(true)
            let currentEmail = newEmailTxt.text!
            let user = Auth.auth().currentUser
            
            DatabaseManager.instance.updateEmailAddress(newEmail: newEmailTxt.text!)
            
            if(currentEmail != user?.email!.description){
                let alertController = UIAlertController(title: "Success", message:
                    "Your email was successfully changed.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

                self.present(alertController, animated: true, completion: nil)
                
                self.performSegue(withIdentifier: "changedEmail", sender: self)
            }  else {
                
                let alertController = UIAlertController(title: "Error", message:
                    "Sorry we couldn't change your email, please try again.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        
    }
    
//    presents an alert on the textfield sent to this function. Acts as an error message. Displays a string to the user, indicating what they entered isn't valid.
    func alert(_ sender: UITextField){
        sender.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
        
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
