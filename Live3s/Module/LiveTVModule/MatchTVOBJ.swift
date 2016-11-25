//
//  MatchTVOBJ.swift
//  Live3s
//
//  Created by codelover2 on 18/01/2016.
//  Copyright © Năm 2016 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class MatchTVOBJ {
    
    let id: String
    let sesson_id: String
    let season_name: String
    let season_url: String
    let country_id: String
    let country_name: String
    let home_club_name: String
    let away_club_name: String
    let home_club_image: String
    let away_club_image: String
    var home_goal: String
    var home_goalH1: String
    var away_goal: String
    var away_goalH1: String
    let home_code: String
    let away_code: String
    let time_start: Double
    let match_vi: String
    let match_fr: String
    let link: String
    var status: String
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.sesson_id = json["sesson_id"].stringValue
        self.season_name = json["season_name"].stringValue
        self.season_url = json["season_url"].stringValue
        self.country_id = json["country_id"].stringValue
        self.country_name = json["country_name"].stringValue
        self.home_club_name = json["home_club_name"].stringValue
        self.away_club_name = json["away_club_name"].stringValue
        self.home_club_image = json["home_club_image"].stringValue
        self.away_club_image = json["away_club_image"].stringValue
        self.home_goal = "0"
        self.away_goal = "0"
        self.home_goalH1 = "0"
        self.away_goalH1 = "0"
        self.home_code = json["home_code"].stringValue
        self.away_code = json["away_code"].stringValue
        self.time_start = json["time_start"].doubleValue
        self.match_vi = json["match_vi"].stringValue
        self.match_fr = json["match_fr"].stringValue
        self.link = json["link"].stringValue
        self.status = ""
    }
}