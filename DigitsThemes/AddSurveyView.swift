//
//  AddSurveyView.swift
//  Deer
//
//  Created by Jacob Sansbury on 9/2/16.
//  Copyright © 2016 Fabric. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import TwitterKit

class AddSurveyView: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var keyField: UITextField!
    let databaseRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        doneFired();
        
        return true
        
    }
    
    @IBAction func doneFired() {
        
        activityIndicator.startAnimating()
        let key = self.keyField.text!
        self.keyField.text = ""
        
        databaseRef.child("/surveys").observeEventType(.Value, withBlock: { (snapshot) in
            
            
            if let surveyWithEntredKey = snapshot.value?[key] {
                let userID = (Twitter.sharedInstance().sessionStore.session()?.userID)!
                
                if  surveyWithEntredKey != nil {
                    
                    self.databaseRef.child("/users-permissions").child(userID).child("granted").child(key).observeEventType(.Value, withBlock: { (snapshot) in
                        
                            let val = snapshot.value!
                            print(val)
                        
                        })
                    
                    let surveyName = String(  (surveyWithEntredKey!["name"]!)!)
                    
                    print("Survey exitst: " + surveyName)
                    self.giveSurveyPermsFromKeyAndUserID(key, userID: userID)
                    
                    self.activityIndicator.stopAnimating()
                    
                    let alert = UIAlertController(title: "Successful!", message:"You've joined the survey: " + surveyName, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                    self.presentViewController(alert, animated: true){}
                
                } else {
                    
                    self.keyField.text = ""
                    print("No such survey")
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    
                    let animation = CABasicAnimation(keyPath: "position")
                    animation.duration = 0.07
                    animation.repeatCount = 4
                    animation.autoreverses = true
                    animation.fromValue = NSValue(CGPoint: CGPointMake(self.keyField.center.x - 10, self.keyField.center.y))
                    animation.toValue = NSValue(CGPoint: CGPointMake(self.keyField.center.x + 10, self.keyField.center.y))
                    self.keyField.layer.addAnimation(animation, forKey: "position")
                    
                    self.activityIndicator.stopAnimating()

                
                }
            }
            
        })
        
        
    }
    
    func giveSurveyPermsFromKeyAndUserID(key: String, userID: String) {
        
        databaseRef.child("/users-permissions").child(userID).child("granted").child(key).setValue(true)
        
    }
    
    
}
