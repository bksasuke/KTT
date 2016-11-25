//
//  LeagueRankRound.swift
//  Live3s
//
//  Created by codelover2 on 18/12/2015.
//  Copyright © Năm 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class LeagueRankCup {
    
    let id: String
    let season_time_id: String
    let season_time_name: String
    let country_id: String
    let name: String
    let result_round: String
    let round_type: String
    let current_ranking: String
    var nameRound : String = ""
    var arraySession = [SessionRankCup]()
    var arrayGroup = [GroupOBJ]()
    var arrayTeam = [TeamOBJ]()
    var arrayMatch = [MatchOBJ]()

    init(json: JSON) {
        self.id = json["id"].stringValue
        self.season_time_id = json["season_time_id"].stringValue
        self.season_time_name = json["season_time_name"].stringValue
        self.country_id = json["country_id"].stringValue
        self.name = json["name"].stringValue
        self.result_round = json["result_round"].stringValue
        self.round_type = json["round_type"].stringValue
        self.current_ranking = json["current_ranking"].stringValue
        
        
            if let allAraaySession = json["list_seasons"].array {
                for subJson: JSON in allAraaySession {
                    let seasonRank = SessionRankCup(json: subJson,typeGroup: self.current_ranking, resultRound: self.result_round)
                    if seasonRank.nameRound != ""{
                        self.nameRound = seasonRank.nameRound
                    }
                    
                    arraySession.append(seasonRank)
                }
                
            }else {
                if let allDicSession = json["list_seasons"].dictionary {
                    for (_, subJson):(String, JSON) in allDicSession {
                        let seasonRank = SessionRankCup(json: subJson,typeGroup: self.current_ranking, resultRound: self.result_round)
                        if seasonRank.nameRound != ""{
                            self.nameRound = seasonRank.nameRound
                        }
                        arraySession.append(seasonRank)
                    }
                    
                }
            }

        if self.current_ranking == "match" {
            if let matchArray = json["ranking_match"].array {
                for allMatch   in matchArray{
                    let match: MatchOBJ = MatchOBJ(json: allMatch)
                    
                    arrayMatch.append(match)
                }
            }
        }else if self.current_ranking == "group" {
            if let allDicGroup = json["ranking_group"].array {
                for subJson:JSON in allDicGroup {
                    let group = GroupOBJ(json: subJson)
                    arrayGroup.append(group)
                }
                
            }
        }else {
            if let teamArray = json["ranking_round"].array {
                for allTeam   in teamArray{
                    let team: TeamOBJ = TeamOBJ(json: allTeam)
                    arrayTeam.append(team)
                }
            }
        }
    }
    
}