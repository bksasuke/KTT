//
//  TipsModule.swift
//  Live3s
//
//  Created by phuc on 2/2/16.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class TipsModule {
    let away_club_id: Int
    let away_club_image: String
    let away_club_name: String
    let away_code: String
    let away_form: String
    let away_goal: Int
    let count_star: Int
    let country_id: Int
    let created_time: Double
    let home_club_id: Int
    let home_club_image: String
    let home_club_name: String
    let home_code: String
    let home_form: String
    let home_goal: Int
    let id: Int
    let is_finish: Int
    let last_update: Double
    let match_id: Int
    let pick: String
    let season_id: Int
    let season_name: String
    let season_order: String
    let season_url: String
    let status: String
    let time_start: Double
    let tip: String
    let vip: String
    
    init(json: JSON) {
        away_club_id = json["away_club_id"].intValue
        away_club_image = json["away_club_image"].stringValue
        away_club_name = json["away_club_name"].stringValue
        away_code = json["away_code"].stringValue
        away_form = json["away_form"].stringValue
        away_goal = json["away_goal"].intValue
        count_star = json["count_star"].intValue
        country_id = json["country_id"].intValue
        created_time = json["created_time"].doubleValue
        home_club_id = json["home_club_id"].intValue
        home_club_image = json["home_club_image"].stringValue
        home_club_name = json["home_club_name"].stringValue
        home_code = json["home_code"].stringValue
        home_form = json["home_form"].stringValue
        home_goal = json["home_goal"].intValue
        id = json["id"].intValue
        is_finish = json["is_finish"].intValue
        last_update = json["last_update"].doubleValue
        match_id = json["match_id"].intValue
        pick = json["pick"].stringValue
        season_id = json["season_id"].intValue
        season_name = json["season_name"].stringValue
        season_order = json["season_order"].stringValue
        season_url = json["season_url"].stringValue
        status = json["status"].stringValue
        time_start = json["time_start"].doubleValue
        tip = json["tip"].stringValue
        vip = json["vip"].stringValue
    }
}