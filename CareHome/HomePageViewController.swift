//
//  HomePageViewController.swift
//  CareHome
//
//  Created by Oscar on 06/02/2020.
//  Copyright © 2020 OscarSanz. All rights reserved.
//

import UIKit
import ResearchKit
import Firebase


//class used to handle the interface of the home screen.
class HomePageViewController: UIViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
//    logs out user when the user clicks the log out button.
    @IBAction func logOutPressed(_ sender: Any) {
        
        do
        {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "loggedOut", sender: self)
        }
        catch let error as NSError
        {
            print (error.localizedDescription)
        }
    
    
    }

}

//extension class of the home page.
extension HomePageViewController : ORKTaskViewControllerDelegate {
    
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
                            if (value != "IntroductionStep" &&
                                value != "FirstSetOfQuestions" &&
                                value != "SecondSetOfQuestions" &&
                                value != "ThirdSetOfQuestions" &&
                                value != "FourthSetOfQuestions" &&
                                value != "SummaryStep"){

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

            print("Final value is: \(finalResult)")

        default:
            print("failed")
        }
        //print("the final result is: \(finalResult)")

//        var finalResult = 0
//        switch(reason){
//        case .completed:
//            let taskResult = taskViewController.result.results
//
//            for stepResult in taskResult! as!  [ORKStepResult] {
//                for result in stepResult.results! {
//
//                    if(Int(result.identifier) != nil){
//                        print(result.identifier)
//                        finalResult = finalResult + Int(result.identifier)!
//                    }
//                }
//            }
//            print(finalResult)
//
//        @unknown default:
//            print(error!)
//        }
        taskViewController.dismiss(animated: true, completion: nil)
    }

   
    
}
