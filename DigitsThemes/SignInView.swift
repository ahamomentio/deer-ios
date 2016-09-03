//
//  SignInView.swift
//  Deer
//
//  Created by Jacob Sansbury on 9/1/16.
//  Copyright © 2016 Fabric. All rights reserved.
//

import UIKit
import TwitterKit
import FirebaseAuth
import Firebase

class SignInView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logInButton = TWTRLogInButton { (session, error) in
            if let unwrappedSession = session {
                
                let credential = FIRTwitterAuthProvider.credentialWithToken(unwrappedSession.authToken, secret: unwrappedSession.authTokenSecret)
                FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                
                    if let e = error {
                        print(e)
                    } else {
                    
                        NSLog("User: %@ logged in", unwrappedSession.userName)
                        delay(1) {
                            self.performSegueWithIdentifier("signedIn", sender: self)
                        }
                    }

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
