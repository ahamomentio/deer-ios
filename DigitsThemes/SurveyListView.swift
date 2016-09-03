//
//  SurveyListView.swift
//  Deer
//
//  Created by Jacob Sansbury on 9/1/16.
//  Copyright © 2016 Fabric. All rights reserved.
//


import UIKit
import TwitterKit
import FirebaseDatabase
import Firebase

class SurveyListView: UITableViewController {
    
    let database = FIRDatabase.database()
    var data: [Survey] = [];
    
    func delay(delay: Double, closure: ()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            closure
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let databaseRef = database.reference().child("/surveys")
        
        databaseRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let surveyDict = snapshot.children
            
            for survey in surveyDict {
                
                print("Adding data " + (survey.value["key"] as! String))
                self.data.append(Survey(type: survey.value["time"] as! String, reward: survey.value["reward"] as! Int, name: survey.value["name"] as! String))
                self.tableView.reloadData()

            }
            
        })
        
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("survey", forIndexPath: indexPath) as! SurveyCell
        cell.surveyName.text = data[indexPath.item].name
        cell.surveyReward.text = "CS " + String(data[indexPath.item].reward)
        cell.surveyTime.text = data[indexPath.item].type
        return cell
    }
    
}
