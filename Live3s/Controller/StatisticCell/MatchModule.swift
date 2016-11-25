//
//  MatchModule.swift
//  Live3s
//
//  Created by codelover2 on 26/02/2016.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class MatchModule {
    
    var id = ""
    var season_id = ""
    var season_name = ""
    var country_id = ""
    var country_name = ""
    var home_club_name = ""
    var away_club_name = ""
    var home_club_image = ""
    var away_club_image = ""
    var home_goal = ""
    var away_goal = ""
    var is_finish = ""
    var time_start = 0.0
    var is_postponed = ""
    var memo = ""
    var status = ""
    var home_goalH1 = ""
    var away_goalH1 = ""
    var match_vi = ""
    var match_fr = ""
    init () {}
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.season_id = json["season_id"].stringValue
        self.season_name = json["season_name"].stringValue
        self.country_id = json["country_id"].stringValue
        self.country_name = json["country_name"].stringValue
        self.home_club_name = json["home_club_name"].stringValue
        self.away_club_name = json["away_club_name"].stringValue
        self.home_club_image = json["home_club_image"].stringValue
        self.away_club_image = json["away_club_image"].stringValue
        self.home_goal = json["home_goal"].stringValue
        self.away_goal = json["away_goal"].stringValue
        self.is_finish = json["is_finish"].stringValue
        self.time_start = json["time_start"].doubleValue
        self.is_postponed = json["is_postponed"].stringValue
        self.memo = json["memo"].stringValue
        self.status = ""
        self.home_goalH1 = json["first_time_home_goal"].stringValue
        self.away_goalH1 = json["first_time_away_goal"].stringValue
        self.match_vi = json["match_vi"].stringValue
        self.match_fr = json["match_fr"].stringValue
    }
    
    init(matchPush: PushNotificationModule){
        self.id = matchPush.match_id
        self.season_id = matchPush.league_id
        self.season_name = matchPush.league_name
        self.country_id = ""
        self.country_name = ""
        self.home_club_name = matchPush.home_club_name
        self.away_club_name = matchPush.away_club_name
        self.home_club_image = ""
        self.away_club_image = ""
        self.home_goal = matchPush.home_goal
        self.away_goal = matchPush.away_goal
        let allTime = matchPush.time_start + 5400
        if allTime < NSDate().timeIntervalSince1970{
            self.is_finish = "1"
        }else{
            self.is_finish = "2"
        }
        self.time_start = matchPush.time_start
        self.is_postponed = "2"
        self.memo = ""
        self.status = ""
        self.home_goalH1 = matchPush.first_time_home_goal
        self.away_goalH1 = matchPush.first_time_away_goal
        self.match_vi = ""
        self.match_fr = ""
       
    }
}