//
//  DatabaseManager.swift
//  CareHome
//
//  Created by Oscar on 29/01/2020.
//  Copyright © 2020 OscarSanz. All rights reserved.
//

import Foundation
import Firebase

//class used to perform queries on the database.
class DatabaseManager {
//    initialise variables
    var db = Firestore.firestore()
    static let instance = DatabaseManager()
    var patients: Array<String> = Array()
    var user = Auth.auth().currentUser?.uid
    var updated = false
//    returns the user account details - the user that logged into the application
    func getUserDetails() -> [String:Any] {
        var data = [String:Any]()
        db.collection("CareStaff").whereField("user_id", isEqualTo: Auth.auth().currentUser!.uid).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else{
                print(error!)
                return
            }
            for doc in querySnapshot!.documents {
                data = doc.data()
            }
            
        }
        return data
    }
    
    
//    updates the email address of the user's account with the new email address sent to the function, stored in 'newEmail'
    func updateEmailAddress(newEmail: String){
        
        let user = Auth.auth().currentUser;
        
        user?.updateEmail(to: newEmail) { error in
            if let error = error {
                print(error)
            } else {
                self.updated = true
            }
            
        }
       
    }
//    function used to send a reset password email to the users account.
    func resetPassword(email: String){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let err = error {
                print(err)
            }
        }
    }
    
    
//function used to create a patient in the database. It adds the account to the cloud Firestore.
    func createPatient(name: String, dateOfBirth: String){
        db.collection("CareStaff").whereField("user_id", isEqualTo: Auth.auth().currentUser?.uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print(err)
            } else {
                for document in querySnapshot!.documents {
                    
                    let id = document.get("HomeCareID")
                    
                    self.db.collection("Patients").addDocument(data: [
                        "FullName":name, "DateOfBirth":dateOfBirth, "HomeCareID": id!]) { err in
                            if let err = err {
                                print(err)
                            }else {
                                print("Patient Successfully created")
                            }
                    }
                }
            }
        }
    }
    
//    this function uploads the calculated QoL score to the cloud firestore. It takes the staffId, home care id, patient name, QoL score, the completion date of the questionnaire and the start date of the questionnaire as parameters.
    func uploadQOLScore(staffID: String, homecareID: Int, patientName: String, qolScore: Int, endDate: Date, startDate: Date){
        db.collection("QoLScores").addDocument(data: ["CareStaffID":staffID, "HomeCareID": homecareID, "PatientName": patientName, "QoLScore": qolScore, "endDate": endDate, "startDate": startDate]){
            err in
            if let err = err {
                print(err)
            } else {
                print("QoLScore successfully uploaded")
            }
        }
    }
    
//    this function returns the QoL scores of a patient dependent on the patient name sent to this function. That patient name is stored in 'patientName'
    func getPatientScores(patientName: String) -> (first: [Int], second: [Date]){
        var h = [Int]()
        var dates = [Date]()
        
        db.collection("QoLScores").whereField("PatientName", isEqualTo: patientName).getDocuments(){ (querySnapshot, err) in
            
            if let err = err {
                print(err)
            } else {
                
                for snap in querySnapshot!.documents {
                    h.append(snap.get("QoLScore") as! Int)
                    dates.append(snap.get("endDate") as! Date)
                }
             
            }
            
        }
       return (h,dates)
    }
    
//    this function calculates the average QoL scores of all care homes passed to the string array 'careHomes'
    func calculateAvgQoLScoresCH(careHomes: [String]) -> [Double]{
        var averageScores: [Double] = []
        var currentID = 0
        for val in careHomes {
            db.collection("CareHome").document(val).getDocument(){ (snapshot, err) in
                if let err = err {
                    print(err)
                } else {
                    
                    currentID = snapshot?.get("ID") as! Int
                    
                    self.db.collection("QoLScores").whereField("HomeCareID", isEqualTo: currentID).getDocuments(){ (querySnap, error) in
                            if let err = error {
                                print(err)
                            } else {
                                var avgScore = 0
                                for doc in querySnap!.documents {
                                    avgScore += Int(doc.get("QoLScore") as! Double)
                                }
                                avgScore = avgScore / querySnap!.documents.count
                                print(avgScore)
                                averageScores.append(Double(avgScore))
                            }
                    }
                         
                }
                      
            }
            
            
            
            if (val == careHomes[careHomes.endIndex-1]){
                return averageScores
            }
        }
        
        return averageScores
    }
    

    
}
