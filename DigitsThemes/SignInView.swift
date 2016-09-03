//
//  SignInView.swift
//  Deer
//
//  Created by Jacob Sansbury on 9/1/16.
//  Copyright © 2016 Fabric. All rights reserved.
//

import UIKit
import TwitterKit

class SignInView: UIViewController {
    
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
        
        let logInButton = TWTRLogInButton { (session, error) in
            if let unwrappedSession = session {
                
                NSLog("User: %@ logged in", unwrappedSession.userName)
                self.delay(1) {
                    self.performSegueWithIdentifier("signedIn", sender: self)
                }
                
            } else {
                NSLog("Login error: %@", error!.localizedDescription);
            }
        }
        
        // TODO: Change where the log in button is positioned in your view
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)

        
    }
    
    
}
