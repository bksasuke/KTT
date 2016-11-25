//
//  MatchUpdateOBJ.swift
//  Live3s
//
//  Created by codelover2 on 17/01/2016.
//  Copyright © Năm 2016 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class MatchUpdateOBJ {
    let match_id: String
    let status: String
    let home_goal: String
    let away_goal: String
    let home_goalH1: String
    let away_goalH1: String
    init(var stringData: String) {
        stringData = stringData.stringByReplacingOccurrencesOfString("", withString: "\"")
        let arrayData = stringData.componentsSeparatedByString(",")
        if arrayData.count > 1 {
            match_id = arrayData[0]
            if arrayData[1] == "Pend." {
                status = AL0604.localization(LanguageKey.penalty_goals)
            }else if arrayData[1] == "Postp."{
                status = AL0604.localization(LanguageKey.postpone)
            }else{
                status = arrayData[1]
            }
            
            home_goal = arrayData[2]
            away_goal = arrayData[3]
            if arrayData[4] == "" {
                home_goalH1 = "0"
            }else {
                 home_goalH1 = arrayData[4]
            }
            if arrayData[5] == "" {
                away_goalH1 = "0"
            }else{
                away_goalH1 = arrayData[5]
            }
            
        }else{
            match_id = ""
            status = ""
            home_goal = ""
            away_goal = ""
            home_goalH1 = ""
            away_goalH1 = ""

        }
    }
}