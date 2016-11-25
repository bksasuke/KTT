//
//  TeamOBJ.swift
//  Live3s
//
//  Created by codelover2 on 20/12/2015.
//  Copyright © Năm 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class TeamOBJ {
    
    let football_club_name: String
    let total_match: String
    let total_point: String
    let total_win: String
    let total_draw: String
    let total_lose: String
    let total_home_goal: String
    let total_away_goal: String
    let total_home_lose_goal: String
    let total_away_lose_goal: String
    let goal: String
    init(json: JSON) {
        self.football_club_name = json["football_club_name"].stringValue
        self.total_match = json["total_match"].stringValue
        self.total_point = json["total_point"].stringValue
        self.total_win = json["total_win"].stringValue
        self.total_draw = json["total_draw"].stringValue
        self.total_lose = json["total_lose"].stringValue
        self.total_home_goal = json["total_home_goal"].stringValue
        self.total_away_goal = json["total_away_goal"].stringValue
        self.total_home_lose_goal = json["total_home_lose_goal"].stringValue
        self.total_away_lose_goal = json["total_away_lose_goal"].stringValue
        
        let intWinGoal = Int(self.total_away_goal)! + Int(self.total_home_goal)!
        let intLoseGoal = Int(self.total_home_lose_goal)! + Int(self.total_away_lose_goal)!
        let inGoal = intWinGoal - intLoseGoal
        self.goal = "\(inGoal)"
        
    }
    
}