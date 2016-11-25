//
//  LeagueRankRound.swift
//  Live3s
//
//  Created by codelover2 on 18/12/2015.
//  Copyright © Năm 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class LeagueRankRound {
    
    let id: String
    let season_time_id: String
    let season_time_name: String
    let country_id: String
    let name: String
    let result_round: String
    let round_type: String
    var arraySession = [SessionRankRound]()
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.season_time_id = json["season_time_id"].stringValue
        self.season_time_name = json["season_time_name"].stringValue
        self.country_id = json["country_id"].stringValue
        self.name = json["name"].stringValue
        self.result_round = json["result_round"].stringValue
        self.round_type = json["round_type"].stringValue
        if let allDicSession = json["list_seasons"].array {
            for subJson:JSON in allDicSession {
                let seasonRank = SessionRankRound(json: subJson)
                arraySession.append(seasonRank)
            }

        }
    }
    
}