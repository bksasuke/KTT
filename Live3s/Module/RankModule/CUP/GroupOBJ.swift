//
//  GroupOBJ.swift
//  Live3s
//
//  Created by codelover2 on 20/12/2015.
//  Copyright © Năm 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class GroupOBJ {
    
    let id: String
    let name: String
    var teams = [TeamOfGroupOBJ]()
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        if let allArrayFC = json["list_fc"].array {
            for teamJson in allArrayFC {
                let team: TeamOfGroupOBJ = TeamOfGroupOBJ(json: teamJson)
                teams.append(team)
            }
            
        }
        
    }
    
}