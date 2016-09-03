//
//  File.swift
//  Deer
//
//  Created by Jacob Sansbury on 9/3/16.
//  Copyright © 2016 Fabric. All rights reserved.
//

import Foundation
import UIKit

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

var currentSurvey = "ABCD"
