//
//  StaticMatchModule.swift
//  Live3s
//
//  Created by codelover2 on 19/02/2016.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class StaticMatchModule  {
    let matchid: String
    let season_id: String
    let season_name: String
    let country_id: String
    let country_name: String
    let awayName: String
    let awayGoal: String
    let homeName: String
    let homeGoal: String
    let home_club_image: String
    let away_club_image: String
    let is_postponed: String
    let is_finish: String
    let memo: String
    let match_vi: String
    let timeStart: Double
    let match_fr: String
    let first_time_home_goal: String
    let first_time_away_goal: String
    
    init(json: JSON) {
        
        matchid =  json["id"].stringValue
        season_id = json["season_id"].stringValue
        season_name = json["season_name"].stringValue
        country_id = json["country_id"].stringValue
        country_name = json["country_id"].stringValue
        awayName = json["away_club_name"].stringValue
        awayGoal = json["away_goal"].stringValue
        away_club_image  = json["away_club_image"].stringValue
        homeName = json["home_club_name"].stringValue
        homeGoal = json["home_goal"].stringValue
        home_club_image = json["home_club_image"].stringValue
        is_postponed  = json["is_postponed"].stringValue
        is_finish  = json["is_finish"].stringValue
        memo  = json["memo"].stringValue
        match_vi  = json["match_vi"].stringValue
        match_fr  = json["match_fr"].stringValue
        timeStart = json["time_start"].doubleValue
        first_time_home_goal = json["first_time_home_goal"].stringValue
        first_time_away_goal = json["first_time_away_goal"].stringValue
    }
}
