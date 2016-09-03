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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        database.reference().child("/surveys/" + currentSurvey + "/questions").observeEventType(.Value, withBlock: { (questionsSnapshot) in
            
            let snapshot = questionsSnapshot.children
            
            for questions in snapshot {
                
                
                let tempTitle = ((questions as! FIRDataSnapshot).value!["q"]!)! as! String
                let tempAnswers = ((questions as! FIRDataSnapshot).value!["a"]!)! as! NSMutableArray
                let tempType = ((questions as! FIRDataSnapshot).value!["type"]!)! as! String as String
                
                self.data.append(Question(type: tempType, possibleAnswers: tempAnswers, questions: tempTitle))
                self.tableView.reloadData()
                
                
            }
            
            })
        
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("question", forIndexPath: indexPath) as! QuestionCell
        
        cell.questionNumb.text = "Question #" + String(indexPath.item + 1)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        currentQuestion = data[indexPath.item]
        currentQNumber = indexPath.item
        
    }
    
}
