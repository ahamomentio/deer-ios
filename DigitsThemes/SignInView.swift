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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logInButton = TWTRLogInButton { (session, error) in
            if let unwrappedSession = session {
                
                NSLog("User: %@ logged in", unwrappedSession.userName)
                delay(1) {
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
