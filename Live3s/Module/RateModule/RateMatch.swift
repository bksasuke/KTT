//
//  RateMatch.swift
//  Live3s
//
//  Created by codelover2 on 10/12/2015.
//  Copyright © Năm 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class RateMatch {
    let season_id: String
    let id: String
    let season_name: String
    let country_id: String
    let country_name: String
    let home_club_name: String
    let away_club_name: String
    let home_club_image: String
    let away_club_image: String
    let asia_ratio: String
    let asia_home: String
    let asia_away: String
    let asia_side: String
    let total_goal_ratio: String
    let above_goal_ratio: String
    let under_goal_ratio: String
    let home_win_europe_ratio: String
    let draw_europe_ratio: String
    let home_lose_europe_ratio: String
    let is_postponed: String
    let is_finish: String
    let time_start: String
    let memo: String
    let match_vi: String
    let match_fr: String
    init(json: JSON) {
        season_id = json["season_id"].stringValue
        id = json["id"].stringValue
        season_name = json["season_name"].stringValue
        country_id = json["country_id"].stringValue
        country_name = json["country_name"].stringValue
        home_club_name = json["home_club_name"].stringValue
        away_club_name = json["away_club_name"].stringValue
        asia_ratio = json["asia_ratio"].stringValue
        asia_home = json["asia_home"].stringValue
        asia_away = json["asia_away"].stringValue
        asia_side = json["asia_side"].stringValue
        total_goal_ratio = json["total_goal_ratio"].stringValue
        above_goal_ratio = json["above_goal_ratio"].stringValue
        under_goal_ratio = json["under_goal_ratio"].stringValue
        home_win_europe_ratio = json["home_win_europe_ratio"].stringValue
        draw_europe_ratio = json["draw_europe_ratio"].stringValue
        home_lose_europe_ratio = json["home_lose_europe_ratio"].stringValue
        home_club_image = json["home_club_image"].stringValue
        away_club_image = json["away_club_image"].stringValue
        is_postponed = json["is_postponed"].stringValue
        is_finish = json["is_finish"].stringValue
        time_start = json["time_start"].stringValue
        memo = json["memo"].stringValue
        match_vi = json["match_vi"].stringValue
        match_fr = json["matcn_fr"].stringValue
    }

}