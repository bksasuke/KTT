//
//  Match.swift
//  Live3s
//
//  Created by phuc on 12/6/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class Match {
    var season_id = ""
    var id = ""
    var away_club_name = ""
    var away_logo = ""
    var away_goal = ""
    var away_goalH1 = ""
    var home_club_name = ""
    var home_logo = ""
    var home_goal = ""
    var home_goalH1 = ""
    var time_start: Double = 0
    var isFinish: Bool = true
    var isPosponse: Bool = true
    var status: String?
    
    init() {
    
    }
    init(json: JSON) {
        season_id = json["season_id"].stringValue.removePHPSpaceCode()
        id = json["id"].stringValue.removePHPSpaceCode()
        away_club_name = json["away_club_name"].stringValue.removePHPSpaceCode()
        away_logo = json["away_club_image"].stringValue.removePHPSpaceCode()
        away_goal = json["away_goal"].stringValue.removePHPSpaceCode()
        home_club_name = json["home_club_name"].stringValue.removePHPSpaceCode()
        home_logo = json["home_club_image"].stringValue.removePHPSpaceCode()
        home_goal = json["home_goal"].stringValue.removePHPSpaceCode()
        time_start = json["time_start"].doubleValue
        let finish = json["is_finish"].intValue
        if finish == 1 {
            isFinish = true
        } else {
            isFinish = false
        }
        let posponse = json["is_postponed"].intValue
        if posponse == 1 {
            isPosponse = true
        } else {
            isPosponse = false
        }
        home_goalH1 = "0"
        away_goalH1 = "0"
    }
    
    init(match: MatchModle) {
        id = match.id!
        season_id = match.season_id!
        away_club_name = match.away_club_name!
        away_logo = match.away_logo!
        away_goal = match.away_goal!
        away_goalH1 = match.away_goalH1!
        home_club_name = match.home_club_name!
        home_logo = match.home_logo!
        home_goal = match.home_goal!
        home_goalH1 =  match.home_goalH1!
        time_start = match.time_start!.doubleValue
        isFinish = match.isFinish!.boolValue
        isPosponse = match.isPosponse!.boolValue
    }
    
    func jsonFromMatch() -> [String: Any] {
        return ["season_id": season_id,
                "id": id,
                "away_club_name": away_club_name,
                "away_club_image": away_logo,
                "away_goal": away_goal,
                "home_club_name": home_club_name,
                "home_club_image": home_logo,
                "home_goal": home_goal,
                "time_start": time_start,
                "is_finish": isFinish]
    }
}