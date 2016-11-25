//
//  TopScoreStandingModule.swift
//  Live3s
//
//  Created by phuc on 3/6/16.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class TopScoreStandingModule {
    var team = "'"
    var name_player = ""
    var number_first_goals = ""
    var number_goals = ""
    var number_penalties = ""
    
    
    init(json: JSON) {
        team = json["team"].stringValue
        name_player = json["name_player"].stringValue
        number_first_goals = json["number_first_goals"].stringValue
        number_goals = json["number_goals"].stringValue
        number_penalties = json["number_penalties"].stringValue
    }
}