//
//  StaticMatch.swift
//  Live3s
//
//  Created by phuc on 1/4/16.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON
class StaticMatch {
    let awayName: String
    let awayGoal: Int
    let homeName: String
    let homeGoal: Int
    let matchId: Int
    let seasonName: String
    let timeStart: Double
    let first_time_home_goal: String
    let first_time_away_goal: String
    
    init(json: JSON) {
        awayName = json["away_club_name"].stringValue
        awayGoal = json["away_goal"].intValue
        homeName = json["home_club_name"].stringValue
        homeGoal = json["home_goal"].intValue
        matchId = json["id"].intValue
        seasonName = json["season_name"].stringValue
        timeStart = json["time_start"].doubleValue
        first_time_home_goal = json["first_time_home_goal"].stringValue
        first_time_away_goal = json["first_time_away_goal"].stringValue
    }
}