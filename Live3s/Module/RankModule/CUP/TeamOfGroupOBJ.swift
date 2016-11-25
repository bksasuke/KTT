//
//  TeamOfGroupOBJ.swift
//  Live3s
//
//  Created by codelover2 on 20/12/2015.
//  Copyright © Năm 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class TeamOfGroupOBJ {
    
    let group_id: String
    let group: String
    let fc_id: String
    let fc_name: String
    let total_win: String
    let total_draw: String
    let total_lose: String
    let total_goal: String
    let total_goal_lose: String
    let point: String
    let subNum: String
    let total_match: String
    init(json: JSON) {
        self.group_id = json["group_id"].stringValue
        self.group = json["group"].stringValue
        self.fc_id = json["fc_id"].stringValue
        self.fc_name = json["fc_name"].stringValue
        self.total_win = json["total_win"].stringValue
        self.total_draw = json["total_draw"].stringValue
        self.total_lose = json["total_lose"].stringValue
        self.total_goal = json["total_goal"].stringValue
        self.total_goal_lose = json["total_goal_lose"].stringValue
        self.point = json["point"].stringValue
        self.total_match = json["total_match"].stringValue
        let intWinGoal = Int(self.total_goal)!
        let intLoseGoal = Int(self.total_goal_lose)!
        let inGoal = intWinGoal - intLoseGoal
        self.subNum = "\(inGoal)"

    }
    
}