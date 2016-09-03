//
//  HomeView.swift
//  Deer
//
//  Created by Jacob Sansbury on 9/1/16.
//  Copyright © 2016 Fabric. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit

class HomeView: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        let uid = (Twitter.sharedInstance().sessionStore.session()?.userID)!
        textLabel.text = "Hi, " + uid
        
    }
}
