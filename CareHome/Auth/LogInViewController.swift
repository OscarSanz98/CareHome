//
//  LogInViewController.swift
//  CareHome
//
//  Created by Oscar on 14/10/2019.
//  Copyright © 2019 OscarSanz. All rights reserved.
//

import UIKit
import Firebase

//Log in class - handles the log in interface
class LogInViewController: UIViewController {

//text field objects initialised and connected
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
//  carry out code inside logInBtn when the log in button has been clicked
    // authenticates the user with the account details entered in the text fields.
    @IBAction func logInBtn(_ sender: Any) {
        if emailTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            alert(emailTxt)
            alert(passwordTxt)
        }else{
            self.view.endEditing(true)
            Auth.auth().signIn(withEmail: emailTxt.text!, password: passwordTxt.text!, completion: { (user, error) in
                
                if error != nil {
                    print(error!)
                } else {
                    print("Log in successful!")
                    self.performSegue(withIdentifier: "goToHomePage", sender: self)
                    
                }
                
            })
        }
    }
    
    // presents an alert on the textfield sent to this function.
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
