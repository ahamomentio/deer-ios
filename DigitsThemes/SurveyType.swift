//
//  SurveyType.swift
//  Deer
//
//  Created by Jacob Sansbury on 9/2/16.
//  Copyright © 2016 Fabric. All rights reserved.
//

import Foundation

class Survey {
    var type: String
    var reward: Int
    var name: String
    
    init(type: String, reward: Int, name: String) {
        self.type = type
        self.name = name
        self.reward = reward
    }
    
    
}
