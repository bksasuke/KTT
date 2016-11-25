//
//  LeagueModule.swift
//  Live3s
//
//  Created by codelover2 on 26/02/2016.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class LeagueModule {
    
    let league_id: String
    let league_name: String
    let league_logo: String
    var matchs = [MatchModule]()

    init(json: JSON) {
        self.league_id = json["league_id"].stringValue
        self.league_name = json["league_name"].stringValue
        self.league_logo = json["league_logo"].stringValue
        if let allArrayRound = json["matches"].array {
            if allArrayRound.count > 0{
                for subJson:JSON in allArrayRound {
                    let match: MatchModule = MatchModule(json: subJson)
                    matchs.append(match)
                }
            }
        }
    }
    
}