//
//  SessionRankRound.swift
//  Live3s
//
//  Created by codelover2 on 18/12/2015.
//  Copyright © Năm 2015 com.phucnguyen. All rights reserved.
//

import Foundation

import SwiftyJSON

class SessionRankCup {
    
    let id: String
    let season_id: String
    let season_name: String
    var nameRound: String = ""
    var rounds = [RoundOBJ]()
    init(json: JSON, typeGroup: String, resultRound: String) {
        self.id = json["id"].stringValue
        self.season_id = json["season_id"].stringValue
        self.season_name = json["season_name"].stringValue
        
        if typeGroup == "match"{
            if let allArrayRound = json["rounds"].array {
                if allArrayRound.count > 0{
                    for subJson:JSON in allArrayRound {
                        let round: RoundOBJ = RoundOBJ(json: subJson)
                        if round.id == resultRound{
                            nameRound = round.name
                        }
                        rounds.append(round)
                    }
                }
            }
        }else{
            if let allDicRound = json["rounds"].array {
                if allDicRound.count > 0{
                    for subJson:JSON in allDicRound {
                        let round: RoundOBJ = RoundOBJ(json: subJson)
                        if round.id == resultRound{
                            nameRound = round.name
                        }
                        rounds.append(round)
                    }
                }
            }
        }
        
       
    }
    
}