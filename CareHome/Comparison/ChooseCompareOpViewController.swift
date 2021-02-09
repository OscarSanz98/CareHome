//  This is used for compare operation choice view controller.
//  ChooseCompareOpViewController.swift
//  CareHome
//
//  Created by Oscar on 22/03/2020.
//  Copyright © 2020 OscarSanz. All rights reserved.
//

import UIKit

//initalise enum variable
enum operationType: Int {
    case compAvgCareHome
    case compPatientsIndividualScore
    case compPatientsAvgScore
}
//class used to handle the interface for choosing which comparison the user may select
class ChooseCompareOpViewController: UIViewController {

  
//initialise the buttons on the interface
    @IBOutlet var avgCareHomeBtn: UIButton!
    @IBOutlet var individualScoreBtn: UIButton!
    @IBOutlet var avgPatientScoresBtn: UIButton!
    
//    set all buttons value for isSelected to false when screen is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avgCareHomeBtn.isSelected = false
        individualScoreBtn.isSelected = false
        avgPatientScoresBtn.isSelected = false
        
        // Do any additional setup after loading the view.
    }
    
//    when the average care home button has been pressed highlight that button to show its selected
    @IBAction func avgCareHomePressed(_ sender: Any) {
        avgCareHomeBtn.backgroundColor = UIColor.blue
        avgCareHomeBtn.setTitle("Selected", for: .normal)
        avgCareHomeBtn.setTitleColor(UIColor.black, for: .normal)
        avgCareHomeBtn.isSelected = true
        

        if(individualScoreBtn.isSelected == true){
            individualScoreBtn.isSelected = false
            individualScoreBtn.setTitle("Select", for: .normal)
            individualScoreBtn.backgroundColor = UIColor(red: 87, green: 1, blue: 225, alpha: 1.0)
        }
        
        
        if(avgPatientScoresBtn.isSelected == true){
            avgPatientScoresBtn.isSelected = false
            avgPatientScoresBtn.setTitle("Select", for: .normal)
            avgPatientScoresBtn.backgroundColor = UIColor(red: 87, green: 1, blue: 225, alpha: 1.0)
        }
        
       
    }
//    when individual patient scores button has been pressed highlight it to show that it has been selected and unhighlight any previously selected buttons.
    @IBAction func individualPatientsScoresPressed(_ sender: Any) {
        individualScoreBtn.backgroundColor = UIColor.blue
        individualScoreBtn.setTitle("Selected", for: .normal)
        individualScoreBtn.setTitleColor(UIColor.black, for: .normal)
        individualScoreBtn.isSelected = true
        

        if(avgCareHomeBtn.isSelected == true){
            avgCareHomeBtn.isSelected = false
            avgCareHomeBtn.setTitle("Select", for: .normal)
            avgCareHomeBtn.backgroundColor = UIColor(red: 87, green: 1, blue: 225, alpha: 1.0)
        }
        
        if(avgPatientScoresBtn.isSelected == true){
            avgPatientScoresBtn.isSelected = false
            avgPatientScoresBtn.setTitle("Select", for: .normal)
            avgPatientScoresBtn.backgroundColor = UIColor(red: 87, green: 1, blue: 225, alpha: 1.0)
        }
        
    }
//    highlight the average patient scores button when clicked.
    @IBAction func averagePatientScoresPressed(_ sender: Any) {
        avgPatientScoresBtn.backgroundColor = UIColor.blue
        avgPatientScoresBtn.setTitle("Selected", for: .normal)
        avgPatientScoresBtn.setTitleColor(UIColor.black, for: .normal)
        avgPatientScoresBtn.isSelected = true
        
               
        if(avgCareHomeBtn.isSelected == true){
            avgCareHomeBtn.isSelected = false
            avgCareHomeBtn.setTitle("Select", for: .normal)
            avgCareHomeBtn.backgroundColor = UIColor(red: 87, green: 1, blue: 225, alpha: 1.0)
        }
       
        if(individualScoreBtn.isSelected == true){
            individualScoreBtn.isSelected = false
            individualScoreBtn.setTitle("Select", for: .normal)
            individualScoreBtn.backgroundColor = UIColor(red: 87, green: 1, blue: 225, alpha: 1.0)
        }
       
    }
    
//    direct the user to the relevant screen dependent on which comparison operation they chose.
    @IBAction func operationChosenPressed(_ sender: Any) {
        
        if avgCareHomeBtn.isSelected == true {
            print("avgCareHome selected")
            self.performSegue(withIdentifier: "avgCareHomeSelected", sender: self)
            
        } else if avgPatientScoresBtn.isSelected == true{
            print("avgPatientScore selected")
            self.performSegue(withIdentifier: "avgPatientQoLSelected", sender: self)
            
        } else if individualScoreBtn.isSelected == true {
            print("individualScore selected")
            self.performSegue(withIdentifier: "individualQoLSelected", sender: self)
        }
    }

   

}
