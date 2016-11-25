//
//  MatchRanking.swift
//  Live3s
//
//  Created by phuc on 12/15/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON


class MatchRanking {
    let clubName: String
    let totalMatch: Int
    let totalWin: Int
    let totalDraw: Int
    let totalLose: Int
    let totalGoal: Int
    let totalPoint: Int
    
    init(json: JSON) {
        clubName = json["football_club_name"].stringValue
        totalMatch = json["total_match"].intValue
        totalWin = json["total_win"].intValue
        totalDraw = json["total_draw"].intValue
        totalLose = json["total_lose"].intValue
        totalGoal = json["goal"].intValue
        totalPoint = json["point"].intValue
    }
}