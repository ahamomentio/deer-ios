//
//  InitView.swift
//  Deer
//
//  Created by Jacob Sansbury on 9/1/16.
//  Copyright © 2016 Fabric. All rights reserved.
//

import UIKit
import TwitterKit

class InitView: UIViewController {
    
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
        
        if let s = Twitter.sharedInstance().sessionStore.session()?.userID {
            NSLog("User: " + s + " already logged in... going to home screen.")
            delay(1) {
                self.performSegueWithIdentifier("signedIn", sender: self)
            }
        } else {
            delay(1) {
                NSLog("User not signed in... taking to sign in screen");
                self.performSegueWithIdentifier("signIn", sender: self)
            }
        }
    }
}
