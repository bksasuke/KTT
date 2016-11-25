//
//  RateSeason.swift
//  Live3s
//
//  Created by codelover2 on 10/12/2015.
//  Copyright © Năm 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON
class RateSeason {
    let league_id: String?
    let league_name: String?
    let league_logo: String?
    var matches = [RateMatch]()
    init(json: JSON) {
      league_id = json["league_id"].stringValue
      league_name = json["league_name"].stringValue
      league_logo = json["league_logo"].stringValue
        if let matchesArray = json["matches"].array {
            for match   in matchesArray{
                let rateMatch: RateMatch = RateMatch(json: match)
                matches.append(rateMatch)
            }
        }
        
    }

}