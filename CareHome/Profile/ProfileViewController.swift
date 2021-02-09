//
//  ProfileViewController.swift
//  CareHome
//
//  Created by Oscar on 29/01/2020.
//  Copyright © 2020 OscarSanz. All rights reserved.
//

import UIKit
import Firebase
//class used for handling the profile interface
class ProfileViewController: UIViewController{
//    initialise and connect labels to the interface.
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    //initialise variable
    let db = Firestore.firestore()
    
//    when screen is loaded, it displays the user's account details
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser!
        emailLabel.text = user.email!.description
        
        db.collection("CareStaff").whereField("user_id", isEqualTo: user.uid).getDocuments(){(querySnapshot, err) in
            
            if let err = err {
                print(err)
            } else {
                for doc in querySnapshot!.documents{
                    self.usernameLabel.text = doc.get("UserName") as? String
                    
                    
                }
            }
        }
        emailLabel.reloadInputViews()
        // Do any additional setup after loading the view.
    }
    
//    before screen is loaded it will display the user's account details.
    override func viewWillAppear(_ animated: Bool) {
        let user = Auth.auth().currentUser!
        emailLabel.text = user.email!.description
        
        db.collection("CareStaff").whereField("user_id", isEqualTo: user.uid).getDocuments(){(querySnapshot, err) in
            
            if let err = err {
                print(err)
            } else {
                for doc in querySnapshot!.documents{
                    self.usernameLabel.text = doc.get("UserName") as? String
                    
                }
            }
        }
        emailLabel.reloadInputViews()
    }
//    calls function resetPassword in DatabaseManager when user clicks the reset password button.
    @IBAction func resetPassword(_ sender: Any) {
        let user = Auth.auth().currentUser
        //print(user?.email?.description)
        
        if let user = user {
            DatabaseManager.instance.resetPassword(email: user.email!.description)
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
