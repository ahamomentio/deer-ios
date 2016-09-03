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
    
        textLabel.text = "Hi, " + (Twitter.sharedInstance().sessionStore.session()?.userID)!
        
    }
}
