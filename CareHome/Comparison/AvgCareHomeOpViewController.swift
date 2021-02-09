//
//  AvgCareHomeOpViewController.swift
//  CareHome
//
//  Created by Oscar on 23/03/2020.
//  Copyright © 2020 OscarSanz. All rights reserved.
//

import UIKit
import Firebase

//class used for handling the average care home operation interface
class AvgCareHomeOpViewController: UIViewController {
//    variables initialised
    var db = Firestore.firestore()
    var careHomes = [String]()
    var cell = UITableViewCell()
    var areasAvailable = [String]()
    var selectedCareHomes: [String] = []
    var averageScores : [String:Double] = [:]
    
    var button = dropDownButton()
    
//table view initialised
    @IBOutlet weak var careHomeTable: UITableView!
   
//    display all care homes in the database system in the table, and add a region filter
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        careHomeTable.allowsMultipleSelection = true
        //careHomeTable.allowsMultipleSelectionDuringEditing = true
        
        db.collection("CareHome").getDocuments(){ (querySnapshot, err) in
        
            if let err = err {
                print(err)
            } else {
            
                self.areasAvailable.append("All")
                for doc in querySnapshot!.documents {
                    if !self.areasAvailable.contains(doc.get("County") as! String){
                        self.areasAvailable.append(doc.get("County") as! String)
                    }
                    //self.careHomes.append(doc.documentID)
                
                }
                
                self.button = dropDownButton.init(frame: CGRect(x: 0, y:0, width: 0, height: 0))
                self.button.setTitleColor(UIColor.black, for: .normal)
                self.button.setTitle("Areas", for: .normal)
                self.button.translatesAutoresizingMaskIntoConstraints = false
                
                //self.button.addTarget(self, action: #selector(self.buttonClicked(_:)), for: .touchUpInside)

                self.view.addSubview(self.button)
                
                self.button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -200).isActive = true
                self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true

                self.button.widthAnchor.constraint(equalToConstant: 950).isActive = true
                self.button.heightAnchor.constraint(equalToConstant: 40).isActive = true

                self.button.dropView.dropDownOptions = self.areasAvailable
                
                
            }

        
        }
        
        self.careHomeTable.addSubview(self.refreshControl)
        
    }
    
//add the refresh function to update the table
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                     #selector(AvgCareHomeOpViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
//    handle the refreshing of the table, reloads the data to show care homes depending on the region specified.
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        getData()
        
        self.careHomeTable.reloadData()
        refreshControl.endRefreshing()
    }

    

    
//    directs user to the screen that displays a graph for the comparison.
    @IBAction func performComparisonPressed(_ sender: Any) {
        //var id = 0
        if let arr = self.careHomeTable.indexPathsForSelectedRows {
            for index in arr {
                print(self.careHomes[index.row])
                self.selectedCareHomes.append(self.careHomes[index.row])
                
            }
            
            
            print(self.averageScores)
            self.performSegue(withIdentifier: "chosenCareHomes", sender: self)
//
//                if self.averageScores.count == self.selectedCareHomes.count {
//                    self.performSegue(withIdentifier: "chosenCareHomes", sender: self)
                //}
            
            
        }
        
        
    }
//    sends data over to the next screen - sends the average quality of life score for each care home.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "chosenCareHomes"){
            let vc = segue.destination as! ResultsAvgCHViewController
            //vc.careHomes = self.selectedCareHomes
            vc.averageScores = self.averageScores
        }
        
        
    }


}


//This is for the main tableView displaying all possible care homes to select
extension AvgCareHomeOpViewController: UITableViewDelegate, UITableViewDataSource {
    
    func getData(){
        if(self.view.contains(self.button)){
        
            if(self.button.currentTitle == "All"){
                db.collection("CareHome").getDocuments(){(querySnapshot, err) in
                    self.careHomes.removeAll()
                    if let err = err {
                        print(err)
                    }else {
                        for doc in querySnapshot!.documents {
                            self.careHomes.append(doc.documentID)
                        }
                        self.careHomeTable.reloadData()
                    }
                    
                }
                
                
            }else if(self.button.currentTitle != "Areas"){
                db.collection("CareHome").whereField("County", isEqualTo: self.button.currentTitle!).getDocuments(){ (querySnapshot, err) in
                    self.careHomes.removeAll()
                    if let err = err {
                        print(err)
                    } else {
                            
                        for doc in querySnapshot!.documents{
                            
                            self.careHomes.append(doc.documentID)
                        }
                        self.careHomeTable.reloadData()
                    }
                }
            } else {
                self.careHomes = []
            }
        }
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.careHomes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "careHomeCell")
        
        
        cell.textLabel?.text = self.careHomes[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow
        self.cell = tableView.cellForRow(at: indexPath!)!
        
        
        addAvgScore()
        //self.selectPatientBtn.isEnabled = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        removeAvgScore(cell: cell)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func removeAvgScore(cell: UITableViewCell){
        if self.averageScores[cell.textLabel!.text!] != nil {
            self.averageScores.removeValue(forKey: cell.textLabel!.text!)
            print(self.averageScores)
        }
    }
    
    func addAvgScore(){
        if let arr = self.careHomeTable.indexPathsForSelectedRows {
            for index in arr {
                let exists = self.averageScores[self.careHomes[index.row]] != nil
                
                if exists == false {
                    let docID = self.careHomes[index.row]
                    db.collection("CareHome").document(docID).getDocument(){ (doc, err) in
                            if let err = err {
                                print(err)
                            } else {
                                let id = doc?.get("ID")
                                //print(id!)
                                self.db.collection("QoLScores").whereField("HomeCareID", isEqualTo: id!).getDocuments(){ (querySnap, er) in
                                    if let err = er {
                                        print(err)
                                    } else {
                                        var avg = 0
                                        //print(querySnap!.documents)
                                        
                                        for document in querySnap!.documents {
                                            //print(document.documentID)
                                            avg += document.get("QoLScore") as! Int
                                        }
                                        if(querySnap!.documents.count != 0){
                                            avg = avg / querySnap!.documents.count
                                            self.averageScores[docID] = Double(avg)
                                           // print(self.averageScores)
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


protocol dropDownProtocol {
    func dropDownPressed(string: String)
}


//class used to handle the dropdown button to select a region.
class dropDownButton: UIButton, dropDownProtocol{
    
    //var db = Firestore.firestore()
    //var avgCareHomeController = AvgCareHomeOpViewController()
    
    func dropDownPressed(string: String) {
        self.setTitle(string, for: .normal)
        self.dismissDropDown()
        //avgCareHomeController.doitForFuckSake()
    }
    
    
    var dropView = dropDownBtnView()
    var height = NSLayoutConstraint()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(red: 85, green: 85, blue: 217, alpha: 1.0)
        
        dropView = dropDownBtnView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
        
        

    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubviewToFront(dropView)
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    var isOpen = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isOpen == false {
            
            isOpen = true
            
            NSLayoutConstraint.deactivate([self.height])
            
            if self.dropView.tableView.contentSize.height > 150 {
                self.height.constant = 150
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
        } else {
            
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
        }
        
        
    }
    
    
    func dismissDropDown(){
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}








class dropDownBtnView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var dropDownOptions = [String] ()
    var tableView = UITableView()
    var delegate: dropDownProtocol!
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        tableView.backgroundColor = UIColor.init(red: 85, green: 85, blue: 217, alpha: 1.0)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //number of sections in the tableview
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //this creates the number of rows for the drop down menu
        //it creates as many as there are in dropdownoptions
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        //sets the text of that row in the drop down menu to the value in dropDownOptions
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        //sets the colour of the dropdown options
        cell.backgroundColor = UIColor.init(red: 85, green: 85, blue: 217, alpha: 1.0)
        //returns the dropdown options
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
      
                
    }
    
    
}
