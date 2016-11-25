//
//  TeamRankRound.swift
//  Live3s
//
//  Created by codelover2 on 18/12/2015.
//  Copyright © Năm 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class MatchOBJ {
    
    let id: String
    let season_name: String
    let home_club_name: String
    let away_club_name: String
    var home_goal: String
    var away_goal: String
    let is_finish: String
    let time_start: String
    let is_postponed: String
    let memo: String
    var status: String
    var home_goalH1: String
    var away_goalH1: String
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.season_name = json["season_name"].stringValue
        self.home_club_name = json["home_club_name"].stringValue
        self.away_club_name = json["away_club_name"].stringValue
        self.home_goal = json["home_goal"].stringValue
        self.away_goal = json["away_goal"].stringValue
        self.is_finish = json["is_finish"].stringValue
        self.time_start = json["time_start"].stringValue
        self.is_postponed = json["is_postponed"].stringValue
        self.memo = json["memo"].stringValue
        status = ""
        home_goalH1 = "0"
        away_goalH1 = "0"
    }
    
}