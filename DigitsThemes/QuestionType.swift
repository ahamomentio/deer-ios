//
//  File.swift
//  Deer
//
//  Created by Jacob Sansbury on 9/3/16.
//  Copyright © 2016 Fabric. All rights reserved.
//

import Foundation

class Question {
    var type: String
    var possibleAnswers: NSMutableArray
    var questions: String
    
    init(type: String, possibleAnswers: NSMutableArray, questions: String) {
        self.type = type
        self.possibleAnswers = possibleAnswers
        self.questions = questions
    }
    
    
}
