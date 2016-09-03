//
//  AccountInfoView.swift
//  Deer
//
//  Created by Jacob Sansbury on 9/3/16.
//  Copyright © 2016 Fabric. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import TwitterKit
import Firebase

class AccountInfoView: UIViewController {
    
    @IBAction func logoutFired() {
        
        try! FIRAuth.auth()?.signOut()
        Twitter.sharedInstance().sessionStore.logOutUserID((Twitter.sharedInstance().sessionStore.session()?.userID)!)
        
        print("Logged out")
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
