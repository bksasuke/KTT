//
//  LeagueTVOBJ.swift
//  Live3s
//
//  Created by codelover2 on 18/01/2016.
//  Copyright © Năm 2016 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class LeagueTVOBJ {

    let league_id: String
    let league_name: String
    let league_logo: String
    var matchs = [MatchTVOBJ]()
    init(json: JSON) {
        self.league_id = json["league_id"].stringValue
        self.league_name = json["league_name"].stringValue
        self.league_logo = json["league_logo"].stringValue
        if let allDicMatchs = json["matches"].array {
            if allDicMatchs.count > 0{
                for subJson:JSON in allDicMatchs {
                    let match: MatchTVOBJ = MatchTVOBJ(json: subJson)
                    matchs.append(match)
                }
            }
        }
        
    }

}