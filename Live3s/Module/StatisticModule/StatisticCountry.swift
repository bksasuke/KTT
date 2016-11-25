//
//  StatisticCountry.swift
//  Live3s
//
//  Created by codelover2 on 14/12/2015.
//  Copyright © Năm 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON
class StatisticCountry {
    let id: String?
    let name: String?
    let country_logo: String?
    init(json: JSON) {
        id = json["id"].stringValue
        name = json["name"].stringValue
        country_logo = json["logo"].stringValue
        
    }

}