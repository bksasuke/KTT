//
//  PushNotificationModule.swift
//  Live3s
//
//  Created by ATCOMPUTER on 09/05/2016.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import Foundation

class PushNotificationModule: NSObject {
    
    let message: String
    let title: String
    let push_type: String
    let app_link: String
    let match_id: String
    let league_id: String
    let league_name: String
    let league_logo: String
    let home_club_name: String
    let away_club_name: String
    let time_start: Double
    var home_goal: String
    var first_time_home_goal: String
    var away_goal: String
    var first_time_away_goal: String
    
    init(data: NSDictionary) {
        if let strMessage = data["message"]!["message"] as? String{
            self.message = strMessage
        }else{
            self.message = ""
        }
        if let strTitle = data["message"]!["title"] as? String{
            self.title = strTitle
        }else{
            self.title = ""
        }
        if let strPushType = data["type"] as? String{
            self.push_type = strPushType
        }else{
            self.push_type = ""
        }
        if let dataMatch = data["message"]!["data"] as? NSDictionary{
            if let appLink = dataMatch["app_link"] as? String{
                self.app_link = appLink
            }else{
                self.app_link = ""
            }
            if let matchID = dataMatch["match_id"] as? String{
                 self.match_id = matchID
            }else{
                 self.match_id = ""
            }
            if let leagueID = dataMatch["league_id"] as? String{
                self.league_id = leagueID
            }else{
                self.league_id = ""
            }
            if let leagueName = dataMatch["league_name"] as? String{
                self.league_name = leagueName
            }else{
                self.league_name = ""
            }
            if let league_logo = dataMatch["league_logo"] as? String{
                self.league_logo = league_logo
            }else{
                self.league_logo = ""
            }
            
            
            if let away_club_name = dataMatch["away_club_name"] as? String{
                self.away_club_name = away_club_name
            }else{
                self.away_club_name = ""
            }
            if let away_goal = dataMatch["away_goal"] as? String{
                self.away_goal = away_goal

            }else{
                self.away_goal = "0"
            }
            if let first_time_away_goal = dataMatch["first_time_away_goal"] as? String{
                  self.first_time_away_goal = first_time_away_goal
            }else{
                  self.first_time_away_goal = ""
            }
            if let home_club_name = dataMatch["home_club_name"] as? String{
                self.home_club_name = home_club_name
            }else{
                self.home_club_name = ""
            }
            if let home_goal = dataMatch["home_goal"] as? String{
                self.home_goal = home_goal
            }else{
                self.home_goal = "0"
            }
            if let first_time_home_goal = dataMatch["first_time_home_goal"] as? String{
                 self.first_time_home_goal = first_time_home_goal
            }else{
                 self.first_time_home_goal = ""
            }
            if let time_start = dataMatch["time_start"] as? String{
                self.time_start = Double(time_start)!

            }else{
                self.time_start = 0

            }
        }else{
            self.app_link = ""
            self.match_id = ""
            self.league_id = ""
            self.league_name = ""
            self.league_logo = ""
            self.away_club_name = ""
            self.time_start = 0
            self.home_club_name = ""
            self.home_goal = ""
            self.first_time_home_goal = ""
            self.away_goal = ""
            self.first_time_away_goal = ""
        }
        
    }

}