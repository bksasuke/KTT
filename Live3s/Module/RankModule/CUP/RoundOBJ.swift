//
//  RoundOBJ.swift
//  Live3s
//
//  Created by codelover2 on 20/12/2015.
//  Copyright © Năm 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class RoundOBJ {
    
    let id: String
    let name: String
    let having_group: String
    let log_rank: String
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.having_group = json["having_group"].stringValue
        self.log_rank = json["log_rank"].stringValue
       
    }
    
}