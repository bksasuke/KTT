//
//  SessionRankRound.swift
//  Live3s
//
//  Created by codelover2 on 18/12/2015.
//  Copyright © Năm 2015 com.phucnguyen. All rights reserved.
//

import Foundation

import SwiftyJSON

class SessionRankRound {
    
    let id: String
    let season_id: String
    let season_name: String
    var teams = [TeamRankRound]()
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.season_id = json["season_id"].stringValue
        self.season_name = json["season_name"].stringValue
        if let teamArray = json["table"].array {
            for allteam   in teamArray{
                let team: TeamRankRound = TeamRankRound(json: allteam)
                teams.append(team)
            }
        }
    }
    
}