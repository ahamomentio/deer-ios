//
//  QuestionsView.swift
//  Deer
//
//  Created by Jacob Sansbury on 9/3/16.
//  Copyright © 2016 Fabric. All rights reserved.
//


import UIKit
import TwitterKit
import FirebaseDatabase
import Firebase
import TwitterKit

class QuestionsView: UITableViewController {
    
    let database = FIRDatabase.database()
    var surveyKeys: [String] = []
    var data: [Question] = []
    
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
        
        database.reference().child("/surveys/" + currentSurvey + "/questions").observeEventType(.Value, withBlock: { (questionsSnapshot) in
            
            let snapshot = questionsSnapshot.children
            
            for questions in snapshot {
                
                print(questions)
                
            }
            
            })
        
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("question", forIndexPath: indexPath) as! QuestionCell
        
        cell.questionNumb.text = "Question #X"
        
        return cell
    }
    
}
