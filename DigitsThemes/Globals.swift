//
//  File.swift
//  Deer
//
//  Created by Jacob Sansbury on 9/3/16.
//  Copyright © 2016 Fabric. All rights reserved.
//

import Foundation

extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}

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

var currentSurvey = "ABCD"
var currentQuestion: Question?
var currentQNumber: Int = 0
