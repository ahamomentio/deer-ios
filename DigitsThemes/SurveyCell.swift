//
//  Cell.swift
//  Deer
//
//  Created by Jacob Sansbury on 9/2/16.
//  Copyright © 2016 Fabric. All rights reserved.
//

import Foundation
import UIKit

class SurveyCell: UITableViewCell {
    
    @IBOutlet weak var surveyName: UILabel!
    @IBOutlet weak var surveyReward: UILabel!
    @IBOutlet weak var surveyTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
