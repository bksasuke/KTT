//
//  StatisticSession.swift
//  Live3s
//
//  Created by codelover2 on 14/12/2015.
//  Copyright © Năm 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON
class StatisticSession {
    let id: String?
    let name: String?
    let country_Id: String?
    let league_logo: String?
    init(json: JSON) {
        id = json["id"].stringValue
        name = json["name"].stringValue
        country_Id = json["country_id"].stringValue
        league_logo = json["league_logo"].stringValue
        
    }
    init(id: String, vi_name: String, fr_name: String){
        self.id = id
        self.name = ""
        country_Id = ""
        league_logo = ""
    }
    init(season: Season) {
        id = season.id
        name = season.name
        country_Id = ""
        league_logo = season.league_logo
    }
    func localizationName() -> String? {
            return name
    }
    
}
