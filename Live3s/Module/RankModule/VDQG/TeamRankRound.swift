//
//  TeamRankRound.swift
//  Live3s
//
//  Created by codelover2 on 18/12/2015.
//  Copyright © Năm 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class TeamRankRound {
    
    let football_club_name: String
    let total_match: String
    let point: String
    let total_win: String
    let total_draw: String
    let total_lose: String
    let goal: String
    init(json: JSON) {
        self.football_club_name = json["football_club_name"].stringValue
        self.total_match = json["total_match"].stringValue
        self.point = json["point"].stringValue
        self.total_win = json["total_win"].stringValue
        self.total_draw = json["total_draw"].stringValue
        self.total_lose = json["total_lose"].stringValue
        self.goal = json["goal"].stringValue
    }
    
}