//
//  NetworkService.swift
//  Live3s
//
//  Created by phuc on 12/6/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum MatchListType: Int {
    case Finish, Future, All, Live
}
struct NetworkService {
    
    private static let manager: Manager = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.requestCachePolicy = .ReloadIgnoringLocalCacheData
        let manager = Manager(configuration: config)
        return manager
    }()
    
    //MARK: - request list language
    
    static func requestLanguage(complete: () -> Void) {
        guard let urlString = "http://v2.live3s.com/m3m12k443m1n311/menu-all.js".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else {return}
        manager.request(.GET, urlString).responseJSON(completionHandler: { response in
            switch response.result {
            case .Success(let value):
                let json = JSON(value)["lang"]
                for (string, subjson) in json {
                    let id = string
                    guard let input = subjson.dictionaryObject else {return}
                    Language.create(input, id: id)
                }
                
                // menu list
                let menuJson = JSON(value)["menu"]
                for (key, menu) in menuJson {
                    let list = MenuList.create(key)
                    for (idx, subJson): (String, JSON) in menu {
                        let module = subJson["module"].stringValue
                        let name = subJson["name"].stringValue
                        Menu.create([
                            "iconUrl": module,
                            "name": name,
                            "index": Int(idx) ?? 0
                            ], owner: list)
                    }
                }
                
                // math push list
                let matPushJson = JSON(value)["match_push"]
                for (key, items) in matPushJson {
                    let list = MatchPushList.create(key)
                    for (_, item) in items {
                        let value = item["value"].stringValue
                        let name = item["name"].stringValue
                        MatchPushItem.create([
                            "value": value,
                            "name": name
                            ], owner: list)
                    }
                }
                complete()
            case .Failure(let error):
                // create default en language                
                debugPrint(error)
                complete()
            }
        })
        
    }
    
    //MARK: - Request Notification
    
    /**
    Push device token to server to pushing notification
    
    - parameter token:      device token
    - parameter completion: block with result: success or failed
    */
    static func registDeviceToken(token: String, completion: (Bool) ->()) {
        let iphoneName = UIDevice.currentDevice().name
        let currentLocale = NSLocale.currentLocale()
        let countryCode = currentLocale.objectForKey(NSLocaleCountryCode)
        guard let urlString = "http://v3.live3s.com/?c=app&m=log_ios&key=m3m12k443m1n311&device=\(token)&name=\(iphoneName)&os=ios&country=\(countryCode!)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else {return}
        
        manager.request(.GET, urlString).responseString(completionHandler: {response in
            
            if let value = response.result.value {
                let success = String("\(value)")
                if success == "success"{
                     completion(true)
                }else{
                     completion(false)
                }
               
            } else {
                completion(false)
            }
        })
    }
    
    // MARK: - Live score API
    
    static func getALlLeague(completion:(json: [JSON]?, error: NSError?) -> ()) {
        let urlString = "http://v2.live3s.com/m3m12k443m1n311/league-\(AL0604.currentLanguage).js"
        let cache = DataCache.findByID(urlString)
        if cache?.urlCache != "" {
            // het thoi gian cache
            let time = Double((cache?.addedTime)!) + Double((cache?.timeCache)!)
            let time2 = NSDate().timeIntervalSince1970
            if time < time2 {
                manager.request(.GET, urlString).validate().responseJSON(completionHandler: {response in
                    switch response.result {
                    case .Success:
                        guard let value = response.result.value else {
                            completion(json: nil, error: nil)
                            return
                        }
                        let json = JSON(value)
                        let cacheValue = value["cache"] as? Double ?? 0
                        if cacheValue > 0{
                            let dataCache = DataCache.findByID(urlString)
                            dataCache?.urlCache = urlString
                            try! dataCache?.dataCache = json.rawData()
                            dataCache?.addedTime = NSDate().timeIntervalSince1970
                            dataCache?.timeCache = cacheValue
                            DataCache.saveData(dataCache!)
                        }
                        let result = json["data"].array
                        completion(json: result, error: nil)
                        break
                    case .Failure:
                        
                        completion(json: nil, error: response.result.error)
                        break
                    }
                })
            }else{
                let cvdata = cache?.dataCache
                let json = JSON(data: cvdata!)
                let result = json["data"].array
                completion(json: result, error: nil)
            }
        }else{
            manager.request(.GET, urlString).validate().responseJSON(completionHandler: {response in
                switch response.result {
                case .Success:
                    guard let value = response.result.value else {
                        completion(json: nil, error: nil)
                        return
                    }
                    let json = JSON(value)
                    let cacheValue = value["cache"] as? Double ?? 0
                    if cacheValue > 0{
                        let dataCache = DataCache.findByID(urlString)
                        dataCache?.urlCache = urlString
                        try! dataCache?.dataCache = json.rawData()
                        dataCache?.addedTime = NSDate().timeIntervalSince1970
                        dataCache?.timeCache = cacheValue
                        DataCache.saveData(dataCache!)
                    }
                    let result = json["data"].array
                    completion(json: result, error: nil)
                    break
                case .Failure:
                    
                    completion(json: nil, error: response.result.error)
                    break
                }
            })
        }
    }
    
    
    /**
     Get line- up and match's stats
     
     - parameter match:      match
     - parameter isFinish:   is match finish
     - parameter completion: completion handle with infor mation of line up and stats
     */
    static func getFormationAndStats(matchID: String, timeStart: Double, isFinish: Bool, completion:(home_formation: [JSON]?, away_formation: [JSON]?, stats: [Stat]?, error: NSError?) -> ()) {

        var urlString = ""
        if isFinish {
            urlString = "http://v3.live3s.com?c=app&m=match_formation_stats&key=m3m12k443m1n311&match_id=\(matchID)&time_start=\(timeStart)&lang=\(AL0604.currentLanguage)"
        } else {
            if timeStart > NSDate().timeIntervalSince1970 {
                urlString = "http://v3.live3s.com/?c=app&m=match_formation_stats&key=m3m12k443m1n311&match_id=\(matchID)&time_start=\(timeStart)"
            }else {
                urlString = "http://v2.live3s.com/m3m12k443m1n311/match-formation-stats/\(matchID).js"
            }
            
        }
        let cache = DataCache.findByID(urlString)
        if cache?.urlCache != "" {
            // het thoi gian cache
            let time = Double((cache?.addedTime)!) + Double((cache?.timeCache)!)
            let time2 = NSDate().timeIntervalSince1970
            if time < time2 {
                manager.request(.GET, urlString).validate().responseJSON(completionHandler: {response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let json = JSON(value)
                            let cacheValue = value["cache"] as? Double ?? 0
                            if cacheValue > 0{
                                let dataCache = DataCache.findByID(urlString)
                                dataCache?.urlCache = urlString
                                try! dataCache?.dataCache = json.rawData()
                                dataCache?.addedTime = NSDate().timeIntervalSince1970
                                dataCache?.timeCache = cacheValue
                                DataCache.saveData(dataCache!)
                            }

                            var home_formation = [JSON]()
                            home_formation.append(json["home_formation_off"])
                            home_formation.append(json["home_formation_sub"])
                            var away_formation = [JSON]()
                            away_formation.append(json["away_formation_off"])
                            away_formation.append(json["away_formation_sub"])
                            // match stat
                            var stats = [Stat]()
                            let statJson = json["match_stats"].array
                            if statJson?.count > 0 {
                                for subJson in statJson! {
                                    let stat = Stat(json: subJson)
                                    if statKeys.contains(stat.statsName) {continue}
                                    stats.append(stat)
                                }
                            }
                            
                            completion(home_formation: home_formation, away_formation: away_formation, stats: stats, error: nil)
                        }
                        break
                    case .Failure:
                        completion(home_formation: nil, away_formation: nil, stats: nil, error: response.result.error)
                        break
                        
                    }
                })
                

            }else{
                let cvdata = cache?.dataCache
                let json = JSON(data: cvdata!)
                var home_formation = [JSON]()
                home_formation.append(json["home_formation_off"])
                home_formation.append(json["home_formation_sub"])
                var away_formation = [JSON]()
                away_formation.append(json["away_formation_off"])
                away_formation.append(json["away_formation_sub"])
                // match stat
                var stats = [Stat]()
                let statJson = json["match_stats"].array
                if statJson?.count > 0 {
                    for subJson in statJson! {
                        let stat = Stat(json: subJson)
                        if statKeys.contains(stat.statsName) {continue}
                        stats.append(stat)
                    }
                }
                
                completion(home_formation: home_formation, away_formation: away_formation, stats: stats, error: nil)
            }
        }else{
            manager.request(.GET, urlString).validate().responseJSON(completionHandler: {response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let cacheValue = value["cache"] as? Double ?? 0
                        if cacheValue > 0{
                            let dataCache = DataCache.findByID(urlString)
                            dataCache?.urlCache = urlString
                            try! dataCache?.dataCache = json.rawData()
                            dataCache?.addedTime = NSDate().timeIntervalSince1970
                            dataCache?.timeCache = cacheValue
                            DataCache.saveData(dataCache!)
                        }

                        var home_formation = [JSON]()
                        home_formation.append(json["home_formation_off"])
                        home_formation.append(json["home_formation_sub"])
                        var away_formation = [JSON]()
                        away_formation.append(json["away_formation_off"])
                        away_formation.append(json["away_formation_sub"])
                        // match stat
                        var stats = [Stat]()
                        let statJson = json["match_stats"].array
                        if statJson?.count > 0 {
                            for subJson in statJson! {
                                let stat = Stat(json: subJson)
                                if statKeys.contains(stat.statsName) {continue}
                                stats.append(stat)
                            }
                        }
                        
                        completion(home_formation: home_formation, away_formation: away_formation, stats: stats, error: nil)
                    }
                    break
                case .Failure:
                    completion(home_formation: nil, away_formation: nil, stats: nil, error: response.result.error)
                    break
                    
                }
            })
            

        }
    }
    
    /**
     Get details match event (ghi ban, thay nguoi, the phat,...)
     
     - parameter match:      match
     - parameter isFinish:   is match finish
     - parameter completion: completion handler
     */
    static func getMatchDetailEvent(matchID: String, isFinish: Bool, completion: (eventList: [MatchDetailEvent]?, error: NSError?) -> Void) {
        var urlString = ""
        if isFinish {
            urlString = GET_MATCHDETAIL_FINISH_EVENT + matchID + "&time_start=100&lang=\(AL0604.currentLanguage)"
        } else {
            urlString = GET_MATCHDETAIL_EVENT + matchID + ".js"
        }
        let cache = DataCache.findByID(urlString)
        if cache?.urlCache != "" {
            // het thoi gian cache
            let time = Double((cache?.addedTime)!) + Double((cache?.timeCache)!)
            let time2 = NSDate().timeIntervalSince1970
            if time < time2 {
                manager.request(.GET, urlString).validate().responseJSON(completionHandler: {response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let json = JSON(value)["data"]
                            let cacheValue = value["cache"] as? Double ?? 0
                            if cacheValue > 0{
                                let dataCache = DataCache.findByID(urlString)
                                dataCache?.urlCache = urlString
                                try! dataCache?.dataCache = json.rawData()
                                dataCache?.addedTime = NSDate().timeIntervalSince1970
                                dataCache?.timeCache = cacheValue
                                DataCache.saveData(dataCache!)
                            }

                            var result = [MatchDetailEvent]()
                            for (_, subJson):(String, JSON) in json {
                                let event = MatchDetailEvent(dict: subJson)
                                result.append(event)
                            }
                            completion(eventList: result, error: nil)
                        }
                        break
                    case .Failure:
                        completion(eventList: nil, error: response.result.error)
                        break
                        
                    }
                })

            }else{
                let cvdata = cache?.dataCache
                let json = JSON(data: cvdata!)
                var result = [MatchDetailEvent]()
                for (_, subJson):(String, JSON) in json {
                    let event = MatchDetailEvent(dict: subJson)
                    result.append(event)
                }
                completion(eventList: result, error: nil)

            }
        }else{
            manager.request(.GET, urlString).validate().responseJSON(completionHandler: {response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)["data"]
                        let cacheValue = value["cache"] as? Double ?? 0
                        if cacheValue > 0{
                            let dataCache = DataCache.findByID(urlString)
                            dataCache?.urlCache = urlString
                            try! dataCache?.dataCache = json.rawData()
                            dataCache?.addedTime = NSDate().timeIntervalSince1970
                            dataCache?.timeCache = cacheValue
                            DataCache.saveData(dataCache!)
                        }

                        var result = [MatchDetailEvent]()
                        for (_, subJson):(String, JSON) in json {
                            let event = MatchDetailEvent(dict: subJson)
                            result.append(event)
                        }
                        completion(eventList: result, error: nil)
                    }
                    break
                case .Failure:
                    completion(eventList: nil, error: response.result.error)
                    break
                    
                }
            })

        }
    }
    
    static func getRanking(leagueID: String, completion: (ranking: [MatchRanking]?, error: NSError?)->()) {
        let urlString = "http://s3.live3s.com/m3m12k443m1n311/standings/\(leagueID)-\(AL0604.currentLanguage).js"
        let cache = DataCache.findByID(urlString)
        if cache?.urlCache != "" {
            // het thoi gian cache
            let time = Double((cache?.addedTime)!) + Double((cache?.timeCache)!)
            let time2 = NSDate().timeIntervalSince1970
            if time < time2 {
                manager.request(.GET, urlString).validate().responseJSON(completionHandler: {response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let json = JSON(value)["data"]["list_seasons"]["1"]["table"]
                            let cacheValue = value["cache"] as? Double ?? 0
                            if cacheValue > 0{
                                let dataCache = DataCache.findByID(urlString)
                                dataCache?.urlCache = urlString
                                try! dataCache?.dataCache = json.rawData()
                                dataCache?.addedTime = NSDate().timeIntervalSince1970
                                dataCache?.timeCache = cacheValue
                                DataCache.saveData(dataCache!)
                            }

                            var result = [MatchRanking]()
                            for (_, subJson):(String, JSON) in json {
                                let event = MatchRanking(json: subJson)
                                result.append(event)
                            }
                            completion(ranking: result, error: nil)
                        }
                        break
                    case .Failure:
                        completion(ranking: nil, error: response.result.error)
                        break
                        
                    }
                })
            }else{
                let cvdata = cache?.dataCache
                let json = JSON(data: cvdata!)
                var result = [MatchRanking]()
                for (_, subJson):(String, JSON) in json {
                    let event = MatchRanking(json: subJson)
                    result.append(event)
                }
                completion(ranking: result, error: nil)
            }
        }else{
            manager.request(.GET, urlString).validate().responseJSON(completionHandler: {response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)["data"]["list_seasons"]["1"]["table"]
                        let cacheValue = value["cache"] as? Double ?? 0
                        if cacheValue > 0{
                            let dataCache = DataCache.findByID(urlString)
                            dataCache?.urlCache = urlString
                            try! dataCache?.dataCache = json.rawData()
                            dataCache?.addedTime = NSDate().timeIntervalSince1970
                            dataCache?.timeCache = cacheValue
                            DataCache.saveData(dataCache!)
                        }

                        var result = [MatchRanking]()
                        for (_, subJson):(String, JSON) in json {
                            let event = MatchRanking(json: subJson)
                            result.append(event)
                        }
                        completion(ranking: result, error: nil)
                    }
                    break
                case .Failure:
                    completion(ranking: nil, error: response.result.error)
                    break
                    
                }
            })
        }
       
    }
    
    
    /**
     Lấy danh sách trận đấu theo nhóm các giải đấu
     
     - parameter completion: completion block sau khi lấy được
     */
    static func getAllMatchs(type: MatchListType, isByTime:Bool, completion: (matchs: [AnyObject]?, error: NSError?)->()) {
        var urlString = ""
        switch type {
        case .Finish:
            if isByTime{
                urlString = "http://v2.live3s.com/m3m12k443m1n311/results-time-\(AL0604.currentLanguage).js"
            }else {
                urlString = "http://v2.live3s.com/m3m12k443m1n311/results-season-\(AL0604.currentLanguage).js"
            }
            
            break
        case .Future:
            if isByTime{
                urlString = "http://v2.live3s.com/m3m12k443m1n311/fixtures-time-\(AL0604.currentLanguage).js"
            }else {
                urlString = "http://v2.live3s.com/m3m12k443m1n311/fixtures-season-\(AL0604.currentLanguage).js"
            }
           
            break
        case .All:
            if isByTime{
                urlString = "http://v2.live3s.com/m3m12k443m1n311/livescore-time-\(AL0604.currentLanguage).js"
            }else {
                urlString = "http://v2.live3s.com/m3m12k443m1n311/livescore-season-\(AL0604.currentLanguage).js"
            }
            
            break
        case .Live:
            if isByTime{
                urlString = "http://v2.live3s.com/m3m12k443m1n311/livescore-live-time-\(AL0604.currentLanguage).js"
            }else {
               urlString = "http://v2.live3s.com/m3m12k443m1n311/livescore-live-season-\(AL0604.currentLanguage).js"
            }
            
            break
        }
        QL2(urlString)
        let cache = DataCache.findByID(urlString)
        if cache?.urlCache != "" {
            // het thoi gian cache
            let time = Double((cache?.addedTime)!) + Double((cache?.timeCache)!)
            let time2 = NSDate().timeIntervalSince1970
            if time < time2 {
                manager.request(.GET, urlString).validate().responseJSON(completionHandler: {response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let json = JSON(value)["data"].arrayValue
                            let cacheValue = value["cache"] as? Double ?? 0
                            if cacheValue > 0{
                                let dataCache = DataCache.findByID(urlString)
                                dataCache?.urlCache = urlString
                                try! dataCache?.dataCache = JSON(value)["data"].rawData()
                                dataCache?.addedTime = NSDate().timeIntervalSince1970
                                dataCache?.timeCache = cacheValue
                                DataCache.saveData(dataCache!)
                            }

                            if json.count == 0{
                                completion(matchs: nil, error: nil)
                                
                            }else{
                                if isByTime{
                                    var arrayMatchs:[MatchModule] = [MatchModule]()
                                    for display: JSON in json {
                                        let matchOBJ = MatchModule(json: display)
                                        arrayMatchs.append(matchOBJ)
                                        completion(matchs: arrayMatchs, error: nil)
                                        
                                    }
                                }else {
                                    var arrayMatchs:[LeagueModule] = [LeagueModule]()
                                    for display:JSON in json {
                                        let matchOBJ = LeagueModule(json: display)
                                        arrayMatchs.append(matchOBJ)
                                        completion(matchs: arrayMatchs, error: nil)
                                        
                                    }
                                }
                            }
                        } else {
                            completion(matchs: nil, error: response.result.error)
                        }
                        break
                    case .Failure:
                        completion(matchs: nil, error: response.result.error)
                        break
                        
                    }
                })
            }else{
                let cvdata = cache?.dataCache
                let json = JSON(data: cvdata!).arrayValue
                if json.count == 0{
                    completion(matchs: nil, error: nil)
                    
                }else{
                    if isByTime{
                        var arrayMatchs:[MatchModule] = [MatchModule]()
                        for display: JSON in json {
                            let matchOBJ = MatchModule(json: display)
                            arrayMatchs.append(matchOBJ)
                            completion(matchs: arrayMatchs, error: nil)
                            
                        }
                    }else {
                        var arrayMatchs:[LeagueModule] = [LeagueModule]()
                        for display:JSON in json {
                            let matchOBJ = LeagueModule(json: display)
                            arrayMatchs.append(matchOBJ)
                            completion(matchs: arrayMatchs, error: nil)
                            
                        }
                    }
                }
            }
        }else{
            manager.request(.GET, urlString).validate().responseJSON(completionHandler: {response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)["data"].arrayValue
                        let cacheValue = value["cache"] as? Double ?? 0
                        if cacheValue > 0{
                            let dataCache = DataCache.findByID(urlString)
                            dataCache?.urlCache = urlString
                            try! dataCache?.dataCache = JSON(value)["data"].rawData()
                            dataCache?.addedTime = NSDate().timeIntervalSince1970
                            dataCache?.timeCache = cacheValue
                            DataCache.saveData(dataCache!)
                        }

                        if json.count == 0{
                            completion(matchs: nil, error: nil)
                            
                        }else{
                            if isByTime{
                                var arrayMatchs:[MatchModule] = [MatchModule]()
                                for display: JSON in json {
                                    let matchOBJ = MatchModule(json: display)
                                    arrayMatchs.append(matchOBJ)
                                    completion(matchs: arrayMatchs, error: nil)
                                    
                                }
                            }else {
                                var arrayMatchs:[LeagueModule] = [LeagueModule]()
                                for display:JSON in json {
                                    let matchOBJ = LeagueModule(json: display)
                                    arrayMatchs.append(matchOBJ)
                                    completion(matchs: arrayMatchs, error: nil)
                                    
                                }
                            }
                        }
                    } else {
                        completion(matchs: nil, error: response.result.error)
                    }
                    break
                case .Failure:
                    completion(matchs: nil, error: response.result.error)
                    break
                    
                }
            })
        }
    }
    
    /**
     Lấy danh sách trận đấu theo nhóm các giải đấu và ngày
     
     - parameter date:       ngày lấy, format "01-12-2015"
     - parameter completion: completion block sau khi lấy được
     */
    static func getAllMatchs(date: String, isByTime: Bool, completion: (matchs: [AnyObject]?, error: NSError?)->()) {
        var urlString = "http://v3.live3s.com/?c=app&m=v1_livescore_season&key=m3m12k443m1n311&lang=\(AL0604.currentLanguage)&date=\(date)"
        if isByTime {
            urlString = "http://v3.live3s.com/?c=app&m=v1_livescore_time&key=m3m12k443m1n311&lang=\(AL0604.currentLanguage)&date=\(date)"
        }
        QL2(urlString)
        let cache = DataCache.findByID(urlString)
        if cache?.urlCache != "" {
            // het thoi gian cache
            let time = Double((cache?.addedTime)!) + Double((cache?.timeCache)!)
            let time2 = NSDate().timeIntervalSince1970
            if time < time2 {
                manager.request(.GET, urlString).validate().responseJSON(completionHandler: {response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let json = JSON(value)["data"].arrayValue
                            let cacheValue = value["cache"] as? Double ?? 0
                            if cacheValue > 0{
                                let dataCache = DataCache.findByID(urlString)
                                dataCache?.urlCache = urlString
                                try! dataCache?.dataCache = JSON(value)["data"].rawData()
                                dataCache?.addedTime = NSDate().timeIntervalSince1970
                                dataCache?.timeCache = cacheValue
                                DataCache.saveData(dataCache!)
                            }
                            if isByTime{
                                var arrayMatchs:[MatchModule] = [MatchModule]()
                                for display:JSON in json {
                                    let matchOBJ = MatchModule(json: display)
                                    arrayMatchs.append(matchOBJ)
                                    completion(matchs: arrayMatchs, error: nil)
                                    
                                }
                            }else {
                                var arrayMatchs:[LeagueModule] = [LeagueModule]()
                                for  subJson: JSON in json {
                                    let matchOBJ = LeagueModule(json: subJson)
                                    arrayMatchs.append(matchOBJ)
                                    completion(matchs: arrayMatchs, error: nil)
                                    
                                }
                            }
                        } else {
                            completion(matchs: nil, error: response.result.error)
                        }
                        break
                    case .Failure:
                        completion(matchs: nil, error: response.result.error)
                        break
                    }
                })

            }else{
                let cvdata = cache?.dataCache
                let json = JSON(data: cvdata!).arrayValue
                if isByTime{
                    var arrayMatchs:[MatchModule] = [MatchModule]()
                    for display:JSON in json {
                        let matchOBJ = MatchModule(json: display)
                        arrayMatchs.append(matchOBJ)
                        completion(matchs: arrayMatchs, error: nil)
                        
                    }
                }else {
                    var arrayMatchs:[LeagueModule] = [LeagueModule]()
                    for  subJson: JSON in json {
                        let matchOBJ = LeagueModule(json: subJson)
                        arrayMatchs.append(matchOBJ)
                        completion(matchs: arrayMatchs, error: nil)
                        
                    }
                }
            }
        }else{
            manager.request(.GET, urlString).validate().responseJSON(completionHandler: {response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)["data"].arrayValue
                        let cacheValue = value["cache"] as? Double ?? 0
                        if cacheValue > 0{
                            let dataCache = DataCache.findByID(urlString)
                            dataCache?.urlCache = urlString
                            try! dataCache?.dataCache = JSON(value)["data"].rawData()
                            dataCache?.addedTime = NSDate().timeIntervalSince1970
                            dataCache?.timeCache = cacheValue
                            DataCache.saveData(dataCache!)
                        }
                        if isByTime{
                            var arrayMatchs:[MatchModule] = [MatchModule]()
                            for display:JSON in json {
                                let matchOBJ = MatchModule(json: display)
                                arrayMatchs.append(matchOBJ)
                                completion(matchs: arrayMatchs, error: nil)
                                
                            }
                        }else {
                            var arrayMatchs:[LeagueModule] = [LeagueModule]()
                            for  subJson: JSON in json {
                                let matchOBJ = LeagueModule(json: subJson)
                                arrayMatchs.append(matchOBJ)
                                completion(matchs: arrayMatchs, error: nil)
                                
                            }
                        }
                    } else {
                        completion(matchs: nil, error: response.result.error)
                    }
                    break
                case .Failure:
                    completion(matchs: nil, error: response.result.error)
                    break
                }
            })
   
        }
    }
    
    /**
     parse response của list trận đấu nhóm theo giải đấu
     
     - parameter json: response json
     
     - returns: Dictionary? có key: Season, value: [Match] là mảng các trận đấu trong giải đấu đó
     */
    static func parseMatchesResponse(json: JSON) -> [Season:[Match]]? {
        var result = [Season: [Match]]()
        for (key, subJson):(String, JSON) in json {
            let sID = key
            if let season = Season.findByID(sID),
                let matches = subJson["matches"].array {
                    season.league_logo = subJson["league_logo"].stringValue
                    var matchesResult = [Match]()
                    for match in matches {
                        let aMatch = Match(json: match)
                        matchesResult.append(aMatch)
                    }
                    result[season] = matchesResult.sort({return $0.time_start < $1.time_start})
            }
        }

        return result
    }
    
    static func parseMatchesResponseBytime(json: JSON) -> [Season: [Match]]? {
        var result = [Season: [Match]]()
        if let season = Season.unknowSeason() {
            var matchesResult = [Match]()
            for match in json.arrayValue {
                let aMatch = Match(json: match)
                matchesResult.append(aMatch)
            }
            result[season] = matchesResult.sort({return $0.time_start < $1.time_start})

        }
        return result
    }
    
    /**
     Lấy danh sách tỉ lệ theo nhóm giải đấu
     - parameter completion: completion block sau khi lấy được
     */
    static func getRateFollowLeague(completion: (matchs: [RateSeason]?, error: NSError?)->()){
        let urlString = "http://v2.live3s.com/m3m12k443m1n311/odds-season-\(AL0604.currentLanguage).js"
        let cache = DataCache.findByID(urlString)
        if cache?.urlCache != "" {
            // het thoi gian cache
            let time = Double((cache?.addedTime)!) + Double((cache?.timeCache)!)
            let time2 = NSDate().timeIntervalSince1970
            if time < time2 {
                manager.request(.GET, urlString).validate().responseJSON(completionHandler:  { response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let json = JSON(value)["data"]
                            let cacheValue = value["cache"] as? Double ?? 0
                            if cacheValue > 0{
                                let dataCache = DataCache.findByID(urlString)
                                dataCache?.urlCache = urlString
                                try! dataCache?.dataCache = JSON(value)["data"].rawData()
                                dataCache?.addedTime = NSDate().timeIntervalSince1970
                                dataCache?.timeCache = cacheValue
                                DataCache.saveData(dataCache!)
                            }
                            var seasonRates = [RateSeason]()
                            for (_, subJson):(String, JSON) in json {
                                let seasonRate = RateSeason(json: subJson)
                                seasonRates.append(seasonRate)
                            }
                            completion(matchs: seasonRates, error: nil)
                        }
                        break
                    case .Failure:
                        completion(matchs: nil, error: response.result.error)
                        break
                    }
                })

            }else{
                let cvdata = cache?.dataCache
                let json = JSON(data: cvdata!)
                var seasonRates = [RateSeason]()
                for (_, subJson):(String, JSON) in json {
                    let seasonRate = RateSeason(json: subJson)
                    seasonRates.append(seasonRate)
                }
                completion(matchs: seasonRates, error: nil)
            }
        }else{
            manager.request(.GET, urlString).validate().responseJSON(completionHandler:  { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)["data"]
                        let cacheValue = value["cache"] as? Double ?? 0
                        if cacheValue > 0{
                            let dataCache = DataCache.findByID(urlString)
                            dataCache?.urlCache = urlString
                            try! dataCache?.dataCache = JSON(value)["data"].rawData()
                            dataCache?.addedTime = NSDate().timeIntervalSince1970
                            dataCache?.timeCache = cacheValue
                            DataCache.saveData(dataCache!)
                        }
                        var seasonRates = [RateSeason]()
                        for (_, subJson):(String, JSON) in json {
                            let seasonRate = RateSeason(json: subJson)
                            seasonRates.append(seasonRate)
                        }
                        completion(matchs: seasonRates, error: nil)
                    }
                    break
                case .Failure:
                    completion(matchs: nil, error: response.result.error)
                    break
                }
            })

        }
    }
    
    static func getFavoriteMatch() -> (Season, [Match]) {
        let season = Season.findByID("0")!
        let favorite = getMatchfavoriteList()
        var result = [Match]()
        for m in favorite {
            let match = Match(match: m)
            result.append(match)
        }
        return (season, result)
    }
    
    /**
     Lấy danh sách tỉ lệ theo ngày
     - parameter date: ngày lấy  <format "01-12-2015">
     - parameter completion: completion block sau khi lấy được
     */
    static func getRateFollowDate(date: String, completion: (matchs: [RateSeason]?, error: NSError?)->()){
        let urlString = "http://v3.live3s.com/?c=app&m=v1_odds_season&key=m3m12k443m1n311&lang=\(AL0604.currentLanguage)&date=\(date)"
        let cache = DataCache.findByID(urlString)
        if cache?.urlCache != "" {
            // het thoi gian cache
            let time = Double((cache?.addedTime)!) + Double((cache?.timeCache)!)
            let time2 = NSDate().timeIntervalSince1970
            if time < time2 {
                manager.request(.GET, urlString).validate().responseJSON(completionHandler:  { response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let json = JSON(value)["data"].arrayValue
                            let cacheValue = value["cache"] as? Double ?? 0
                            if cacheValue > 0{
                                let dataCache = DataCache.findByID(urlString)
                                dataCache?.urlCache = urlString
                                try! dataCache?.dataCache = JSON(value)["data"].rawData()
                                dataCache?.addedTime = NSDate().timeIntervalSince1970
                                dataCache?.timeCache = cacheValue
                                DataCache.saveData(dataCache!)
                            }
                            var seasonRates = [RateSeason]()
                            for subJson: JSON in json {
                                let seasonRate = RateSeason(json: subJson)
                                seasonRates.append(seasonRate)
                            }
                            completion(matchs: seasonRates, error: nil)
                        }
                        break
                    case .Failure:
                        completion(matchs: nil, error: response.result.error)
                        break
                    }
                })

            }else{
                let cvdata = cache?.dataCache
                let json = JSON(data: cvdata!).arrayValue
                var seasonRates = [RateSeason]()
                for subJson: JSON in json {
                    let seasonRate = RateSeason(json: subJson)
                    seasonRates.append(seasonRate)
                }
                completion(matchs: seasonRates, error: nil)
            }
        }else{
            manager.request(.GET, urlString).validate().responseJSON(completionHandler:  { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)["data"].arrayValue
                        let cacheValue = value["cache"] as? Double ?? 0
                        if cacheValue > 0{
                            let dataCache = DataCache.findByID(urlString)
                            dataCache?.urlCache = urlString
                            try! dataCache?.dataCache = JSON(value)["data"].rawData()
                            dataCache?.addedTime = NSDate().timeIntervalSince1970
                            dataCache?.timeCache = cacheValue
                            DataCache.saveData(dataCache!)
                        }
                        var seasonRates = [RateSeason]()
                        for subJson: JSON in json {
                            let seasonRate = RateSeason(json: subJson)
                            seasonRates.append(seasonRate)
                        }
                        completion(matchs: seasonRates, error: nil)
                    }
                    break
                case .Failure:
                    completion(matchs: nil, error: response.result.error)
                    break
                }
            })

        }
    }
    /**
     Lấy BXH VDQG
     - parameter date: league_id
     - parameter completion: completion block sau khi lấy được
     */
    static func getRankVDQG(leagueID: String, completion: (league: AnyObject?, roundType: String, error: NSError?)->()){
        let urlString = GET_BXH_OF_LEAGUE + leagueID + "-\(AL0604.currentLanguage)" + ".js"
         let cache = DataCache.findByID(urlString)
        if cache?.urlCache != "" {
            // het thoi gian cache
            let time = Double((cache?.addedTime)!) + Double((cache?.timeCache)!)
            let time2 = NSDate().timeIntervalSince1970
            if time < time2 {
                manager.request(.GET, urlString).validate().responseJSON(completionHandler:  { response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let json = JSON(value)["data"]
                            let cacheValue = value["cache"] as? Double ?? 0
                            if cacheValue > 0{
                                let dataCache = DataCache.findByID(urlString)
                                dataCache?.urlCache = urlString
                                try! dataCache?.dataCache = json.rawData()
                                dataCache?.addedTime = NSDate().timeIntervalSince1970
                                dataCache?.timeCache = cacheValue
                                DataCache.saveData(dataCache!)
                            }
                            let round_type: String = json["round_type"].stringValue
                            if round_type == "1" {
                                let league = LeagueRankRound(json: json)
                                completion(league: league, roundType: round_type, error: nil)
                            }else{
                                let league = LeagueRankCup(json: json)
                                completion(league: league, roundType: round_type, error: nil)
                            }
                        }
                        break
                    case .Failure:
                        completion(league: nil, roundType: "", error: response.result.error)
                        break
                    }
                })
                
            // Nằm trong thời gian cache
            }else{
                let cvdata = cache?.dataCache
                let json = JSON(data: cvdata!)
                let round_type: String = json["round_type"].stringValue
                if round_type == "1" {
                    let league = LeagueRankRound(json: json)
                    completion(league: league, roundType: round_type, error: nil)
                }else{
                    let league = LeagueRankCup(json: json)
                    completion(league: league, roundType: round_type, error: nil)
                }

            }
            // chưa cache
        }else{
            manager.request(.GET, urlString).validate().responseJSON(completionHandler:  { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)["data"]
                        let cacheValue = value["cache"] as? Double ?? 0
                        if cacheValue > 0{
                            let dataCache = DataCache.findByID(urlString)
                            dataCache?.urlCache = urlString
                            try! dataCache?.dataCache = json.rawData()
                            dataCache?.addedTime = NSDate().timeIntervalSince1970
                            dataCache?.timeCache = cacheValue
                            DataCache.saveData(dataCache!)
                        }
                        let round_type: String = json["round_type"].stringValue
                        if round_type == "1" {
                            let league = LeagueRankRound(json: json)
                            completion(league: league, roundType: round_type, error: nil)
                        }else{
                            let league = LeagueRankCup(json: json)
                            completion(league: league, roundType: round_type, error: nil)
                        }
                    }
                    break
                case .Failure:
                    completion(league: nil, roundType: "", error: response.result.error)
                    break
                }
            })

        }
        
    }
    
    /**
     Lấy BXH Dau Cup
     - parameter date: league_id
     - parameter completion: completion block sau khi lấy được
     */
    static func getRankCup(leagueID: String, completion: (league: LeagueRankCup?, error: NSError?)->()){
        let urlString = GET_BXH_OF_LEAGUE + leagueID + "-\(AL0604.currentLanguage)" + ".js"
        let cache = DataCache.findByID(urlString)
        if cache?.urlCache != "" {
            // het thoi gian cache
            let time = Double((cache?.addedTime)!) + Double((cache?.timeCache)!)
            let time2 = NSDate().timeIntervalSince1970
            if time < time2 {
                manager.request(.GET, urlString).validate().responseJSON(completionHandler:  { response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let json = JSON(value)["data"]
                            let cacheValue = value["cache"] as? Double ?? 0
                            if cacheValue > 0{
                                let dataCache = DataCache.findByID(urlString)
                                dataCache?.urlCache = urlString
                                try! dataCache?.dataCache = JSON(value)["data"].rawData()
                                dataCache?.addedTime = NSDate().timeIntervalSince1970
                                dataCache?.timeCache = cacheValue
                                DataCache.saveData(dataCache!)
                            }
                            let league = LeagueRankCup(json: json)
                            completion(league: league, error: nil)
                        }
                        break
                    case .Failure:
                        completion(league: nil, error: response.result.error)
                        break
                    }
                })

            }else{
                let cvdata = cache?.dataCache
                let json = JSON(data: cvdata!)
                let league = LeagueRankCup(json: json)
                completion(league: league, error: nil)
            }
        }else{
            manager.request(.GET, urlString).validate().responseJSON(completionHandler:  { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)["data"]
                        let cacheValue = value["cache"] as? Double ?? 0
                        if cacheValue > 0{
                            let dataCache = DataCache.findByID(urlString)
                            dataCache?.urlCache = urlString
                            try! dataCache?.dataCache = JSON(value)["data"].rawData()
                            dataCache?.addedTime = NSDate().timeIntervalSince1970
                            dataCache?.timeCache = cacheValue
                            DataCache.saveData(dataCache!)
                        }
                        let league = LeagueRankCup(json: json)
                        completion(league: league, error: nil)
                    }
                    break
                case .Failure:
                    completion(league: nil, error: response.result.error)
                    break
                }
            })
 
        }
    }
    
    /**
     Lấy Giải Đấu của một quốc gia
     - parameter date: country_id
     - parameter completion: completion block sau khi lấy được
     */
    static func getLeagueOfCountry(country_id: String, completion: (leagues: [JSON]?, error: NSError?)->()){
        let urlString = "http://v2.live3s.com/m3m12k443m1n311/country/\(country_id)-\(AL0604.currentLanguage).js"
            manager.request(.GET, urlString).validate().responseJSON(completionHandler:  { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)["data"]
                        let arrayLeague = json.arrayValue
                        completion(leagues: arrayLeague, error: nil)
                    }
                    break
                case .Failure:
                    completion(leagues: nil, error: response.result.error)
                    break
                }
            })
    }
    
    /**
     Lấy BXH theo Round
     - parameter date: league_id, season_id, round_id
     - parameter completion: completion block sau khi lấy được
     */
    static func getBXHFollowRound(typeRank: String, league_id: String, session_id:String , round_id:String, completion: (leagues: AnyObject?, error: NSError?)->()){
        let urlString = "http://v3.live3s.com/?c=app&m=\(typeRank)&key=m3m12k443m1n311&lang=\(AL0604.currentLanguage)&league_id=\(league_id)&season_id=\(session_id)&round_id=\(round_id)"
            manager.request(.GET, urlString).validate().responseJSON(completionHandler:  { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        
                        if typeRank == "v1_match_ranking" {
                            var arrayMatch:[MatchOBJ]? = [MatchOBJ]()
                            let json = JSON(value)["data"]
                            let array = json.arrayValue
                            for display in array {
                                let matchOBJ = MatchOBJ(json: display)
                                arrayMatch?.append(matchOBJ)
                                
                            }
                            completion(leagues: arrayMatch, error: nil)
                            
                        }else if typeRank == "v1_group_ranking"{
                            var arrayGroup:[GroupOBJ]? = [GroupOBJ]()
                            let json = JSON(value)["ranking_group"]
                            let cacheValue = value["cache"] as? Double ?? 0
                            if cacheValue > 0{
                                let dataCache = DataCache.findByID(urlString)
                                dataCache?.urlCache = urlString
                                try! dataCache?.dataCache = JSON(value).rawData()
                                dataCache?.addedTime = NSDate().timeIntervalSince1970
                                dataCache?.timeCache = cacheValue
                                DataCache.saveData(dataCache!)
                            }
                            for (_, display):(String, JSON) in json {
                                let groupOBJ = GroupOBJ(json: display)
                                arrayGroup?.append(groupOBJ)
                                
                                
                            }
                            completion(leagues: arrayGroup, error: nil)
                        }else{
                            var arrayRound:[TeamOBJ]? = [TeamOBJ]()
                            let json = JSON(value)["data"]
                            let cacheValue = value["cache"] as? Double ?? 0
                            if cacheValue > 0{
                                let dataCache = DataCache.findByID(urlString)
                                dataCache?.urlCache = urlString
                                try! dataCache?.dataCache = JSON(value).rawData()
                                dataCache?.addedTime = NSDate().timeIntervalSince1970
                                dataCache?.timeCache = cacheValue
                                DataCache.saveData(dataCache!)
                            }
                            let array = json.arrayValue
                            for display in array {
                                let roundOBJ = TeamOBJ(json: display)
                                arrayRound?.append(roundOBJ)
                                
                                
                            }
                            completion(leagues: arrayRound, error: nil)
                        }
                        
                    }
                    break
                case .Failure:
                    completion(leagues: nil, error: response.result.error)
                    break
                }
            })
    }
    
    /**
     Lấy thông tin đối đầu, thông tin phong độ gần đây của 2 đội bóng trong 1 trận đấu
     
     - parameter isPlaying: trận đấu đã diễn ra hay chưa
     */
    static func getMatchStatics(matchID: String, isPlaying: Bool, completionBlock:(staticList: ([StaticMatch], [StaticMatch], [StaticMatch])?,leagueID:String, error: NSError? ) -> Void) {
        var urlString = ""
        if isPlaying {
            urlString = "http://v3.live3s.com/?c=app&m=match_h2h&key=m3m12k443m1n311&id=\(matchID)&lang=\(AL0604.currentLanguage)"
        } else {
            urlString = "http://v3.live3s.com/?c=app&m=match_h2h&key=m3m12k443m1n311&id=\(matchID)&lang=\(AL0604.currentLanguage)"
        }
        QL2(urlString)
        let cache = DataCache.findByID(urlString)
        if cache?.urlCache != "" {
            // het thoi gian cache
            let time = Double((cache?.addedTime)!) + Double((cache?.timeCache)!)
            let time2 = NSDate().timeIntervalSince1970
            if time < time2 {
                manager.request(.GET, urlString).responseJSON(completionHandler: {response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let cacheValue = value["cache"] as? Double ?? 0
                            if cacheValue > 0{
                                let dataCache = DataCache.findByID(urlString)
                                dataCache?.urlCache = urlString
                                try! dataCache?.dataCache = JSON(value).rawData()
                                dataCache?.addedTime = NSDate().timeIntervalSince1970
                                dataCache?.timeCache = cacheValue
                                DataCache.saveData(dataCache!)
                            }
                            //leagueID
                            var matchJSon = JSON(value)["match"].dictionary
                            let leagueID = matchJSon!["league_id"]?.stringValue
                            
                            // home
                            var home = [StaticMatch]()
                            let homeJson = JSON(value)["home_form"].arrayValue
                            for entity in homeJson {
                                let matchStatic = StaticMatch(json: entity)
                                home.append(matchStatic)
                            }
                            // away
                            var away = [StaticMatch]()
                            let awayJson = JSON(value)["away_form"].arrayValue
                            for entity in awayJson {
                                let matchStatic = StaticMatch(json: entity)
                                away.append(matchStatic)
                            }
                            // head to head
                            var h2h = [StaticMatch]()
                            let h2hJson = JSON(value)["h2h"].arrayValue
                            for entity in h2hJson {
                                let matchStatic = StaticMatch(json: entity)
                                h2h.append(matchStatic)
                            }
                            let staticList = (home, away, h2h)
                            completionBlock(staticList: staticList, leagueID: leagueID!,error: nil)
                        } else {
                            completionBlock(staticList: nil,leagueID:"",  error: nil)
                        }
                        break
                    case .Failure:
                        completionBlock(staticList: nil, leagueID: "" ,error: response.result.error)
                        break
                    }
                })
            }else{
                let cvdata = cache?.dataCache
                let json = JSON(data: cvdata!)
                
                //leagueID
                var matchJSon = json["match"].dictionary
                let leagueID = matchJSon!["league_id"]?.stringValue
                
                // home
                var home = [StaticMatch]()
                let homeJson = json["home_form"].arrayValue
                for entity in homeJson {
                    let matchStatic = StaticMatch(json: entity)
                    home.append(matchStatic)
                }
                // away
                var away = [StaticMatch]()
                let awayJson = json["away_form"].arrayValue
                for entity in awayJson {
                    let matchStatic = StaticMatch(json: entity)
                    away.append(matchStatic)
                }
                // head to head
                var h2h = [StaticMatch]()
                let h2hJson = json["h2h"].arrayValue
                for entity in h2hJson {
                    let matchStatic = StaticMatch(json: entity)
                    h2h.append(matchStatic)
                }
                let staticList = (home, away, h2h)
                completionBlock(staticList: staticList, leagueID:leagueID!,error: nil)
            }
        }else{
            manager.request(.GET, urlString).responseJSON(completionHandler: {response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let cacheValue = value["cache"] as? Double ?? 0
                        if cacheValue > 0{
                            let dataCache = DataCache.findByID(urlString)
                            dataCache?.urlCache = urlString
                            try! dataCache?.dataCache = JSON(value).rawData()
                            dataCache?.addedTime = NSDate().timeIntervalSince1970
                            dataCache?.timeCache = cacheValue
                            DataCache.saveData(dataCache!)
                        }
                        
                        //leagueID
                        var matchJSon = JSON(value)["match"].dictionary
                        let leagueID = matchJSon!["league_id"]?.stringValue
                        
                        // home
                        var home = [StaticMatch]()
                        let homeJson = JSON(value)["home_form"].arrayValue
                        for entity in homeJson {
                            let matchStatic = StaticMatch(json: entity)
                            home.append(matchStatic)
                        }
                        // away
                        var away = [StaticMatch]()
                        let awayJson = JSON(value)["away_form"].arrayValue
                        for entity in awayJson {
                            let matchStatic = StaticMatch(json: entity)
                            away.append(matchStatic)
                        }
                        // head to head
                        var h2h = [StaticMatch]()
                        let h2hJson = JSON(value)["h2h"].arrayValue
                        for entity in h2hJson {
                            let matchStatic = StaticMatch(json: entity)
                            h2h.append(matchStatic)
                        }
                        let staticList = (home, away, h2h)
                        completionBlock(staticList: staticList, leagueID:leagueID!, error: nil)
                    } else {
                        completionBlock(staticList: nil, leagueID:"", error: nil)
                    }
                    break
                case .Failure:
                    completionBlock(staticList: nil, leagueID:"", error: response.result.error)
                    break
                }
            })
        }
       
        
    }

    /**
     Lấy thông tin trận đấu live
     */
    static func getUpdateMatch(completionBlock:(matchUpdate: [MatchUpdateOBJ]?, error: NSError?) -> Void ) {
        let urlString = API_UPDATE_MATCH
        manager.request(.GET, urlString).validate().responseString(completionHandler: { response in
            switch response.result{
            case .Success:
                    if let value = response.result.value {
                        let arrayValue = value .componentsSeparatedByString(";")
                        var arrayUpdate = [MatchUpdateOBJ]()
                        for stringData  in arrayValue{
                            let obj = MatchUpdateOBJ(stringData: stringData)
                            if obj.match_id != ""{
                                arrayUpdate.append(obj)
                            }
                            
                        }
                        completionBlock(matchUpdate: arrayUpdate, error: response.result.error)
                    }
                    break
                    case .Failure:
                    completionBlock(matchUpdate: nil, error: response.result.error)
                    break
            }
        })
    }
    /**
    Lấy danh sách tường thuật trực tiếp
    */
    static func getLiveTV(isLiveTV: Bool, completionBlock: (league: [LeagueTVOBJ]?, error: NSError?) -> Void ){
        
        var urlString = "http://v2.live3s.com/m3m12k443m1n311/matchtv-season.js"
        if isLiveTV {
            urlString = "http://v2.live3s.com/m3m12k443m1n311/livetv-season.js"
        }
        let cache = DataCache.findByID(urlString)
        if cache?.urlCache != "" {
            // het thoi gian cache
            let time = Double((cache?.addedTime)!) + Double((cache?.timeCache)!)
            let time2 = NSDate().timeIntervalSince1970
            if time < time2 {
                manager.request(.GET, urlString).responseJSON(completionHandler: { response in
                    switch response.result{
                    case .Success:
                        if let value  = response.result.value {
                            let json = JSON(value)["data"]
                            let cacheValue = value["cache"] as? Double ?? 0
                            if cacheValue > 0{
                                let dataCache = DataCache.findByID(urlString)
                                dataCache?.urlCache = urlString
                                try! dataCache?.dataCache = JSON(value)["data"].rawData()
                                dataCache?.addedTime = NSDate().timeIntervalSince1970
                                dataCache?.timeCache = cacheValue
                                DataCache.saveData(dataCache!)
                            }
                            var leagues = [LeagueTVOBJ]()
                            for (_, subJson):(String, JSON) in json {
                                let league = LeagueTVOBJ(json: subJson)
                                leagues.append(league)
                            }
                            
                            completionBlock(league: leagues, error: nil)
                        }
                        break
                    case .Failure:
                        completionBlock(league: nil, error: response.result.error)
                        break
                        
                    }
                })

            }else{
                let cvdata = cache?.dataCache
                let json = JSON(data: cvdata!)
                var leagues = [LeagueTVOBJ]()
                for (_, subJson):(String, JSON) in json {
                    let league = LeagueTVOBJ(json: subJson)
                    leagues.append(league)
                }
                completionBlock(league: leagues, error: nil)
            }
        }else{
            manager.request(.GET, urlString).responseJSON(completionHandler: { response in
                switch response.result{
                case .Success:
                    if let value  = response.result.value {
                        let json = JSON(value)["data"]
                        let cacheValue = value["cache"] as? Double ?? 0
                        if cacheValue > 0{
                            let dataCache = DataCache.findByID(urlString)
                            dataCache?.urlCache = urlString
                            try! dataCache?.dataCache = json.rawData()
                            dataCache?.addedTime = NSDate().timeIntervalSince1970
                            dataCache?.timeCache = cacheValue
                            DataCache.saveData(dataCache!)
                        }
                        var leagues = [LeagueTVOBJ]()
                        for (_, subJson):(String, JSON) in json {
                            let league = LeagueTVOBJ(json: subJson)
                            leagues.append(league)
                        }
                        
                        completionBlock(league: leagues, error: nil)
                    }
                    break
                case .Failure:
                    completionBlock(league: nil, error: response.result.error)
                    break
                    
                }
            })

        }
        
    }
    /**
    Lấy link rate app
    */
    static func getLinkRateApp(completionBlock: (strLink: String?, error: NSError?) -> Void) {
        let urlString = GET_LINK_RATE_APP
        let cache = DataCache.findByID(urlString)
        if cache?.urlCache != "" {
            // het thoi gian cache
            let time = Double((cache?.addedTime)!) + Double((cache?.timeCache)!)
            let time2 = NSDate().timeIntervalSince1970
            if time < time2 {
                manager.request(.GET, urlString).responseJSON(completionHandler: { respone in
                    switch respone.result{
                    case .Success:
                        if let value  = respone.result.value {
                            let json = JSON(value)["data"]
                            let cacheValue = value["cache"] as? Double ?? 0
                            if cacheValue > 0{
                                let dataCache = DataCache.findByID(urlString)
                                dataCache?.urlCache = urlString
                                try! dataCache?.dataCache = json.rawData()
                                dataCache?.addedTime = NSDate().timeIntervalSince1970
                                dataCache?.timeCache = cacheValue
                                DataCache.saveData(dataCache!)
                            }
                            let stringRate = json["ios"].stringValue
                            
                            completionBlock(strLink: stringRate, error: nil)
                        }
                        break
                    case .Failure:
                        completionBlock(strLink: nil, error: respone.result.error)
                        break
                    }
                })

            }else{
                let cvdata = cache?.dataCache
                let json = JSON(data: cvdata!)
                let stringRate = json["ios"].stringValue
                completionBlock(strLink: stringRate, error: nil)

            }
        }else{
            manager.request(.GET, urlString).responseJSON(completionHandler: { respone in
                switch respone.result{
                case .Success:
                    if let value  = respone.result.value {
                        let json = JSON(value)["data"]
                        let cacheValue = value["cache"] as? Double ?? 0
                        if cacheValue > 0{
                            let dataCache = DataCache.findByID(urlString)
                            dataCache?.urlCache = urlString
                            try! dataCache?.dataCache = json.rawData()
                            dataCache?.addedTime = NSDate().timeIntervalSince1970
                            dataCache?.timeCache = cacheValue
                            DataCache.saveData(dataCache!)
                        }
                        let stringRate = json["ios"].stringValue
                        
                        completionBlock(strLink: stringRate, error: nil)
                    }
                    break
                case .Failure:
                    completionBlock(strLink: nil, error: respone.result.error)
                    break
                }
            })
   
        }
    }
    /**
     Lấy related app
     */
    static func getRelatedApp(completionBlock: (relatedApps: [RelatedAppOBJ]?, error: NSError?) -> Void) {
        let urlString = GET_RELATED_APP
        let cache = DataCache.findByID(urlString)
        if cache?.urlCache != "" {
            // het thoi gian cache
            let time = Double((cache?.addedTime)!) + Double((cache?.timeCache)!)
            let time2 = NSDate().timeIntervalSince1970
            if time < time2 {
                manager.request(.GET, urlString).responseJSON(completionHandler: { respone in
                    switch respone.result{
                    case .Success:
                        if let value  = respone.result.value {
                            let json = JSON(value)["data"]
                            let cacheValue = value["cache"] as? Double ?? 0
                            if cacheValue > 0{
                                let dataCache = DataCache.findByID(urlString)
                                dataCache?.urlCache = urlString
                                try! dataCache?.dataCache = json.rawData()
                                dataCache?.addedTime = NSDate().timeIntervalSince1970
                                dataCache?.timeCache = cacheValue
                                DataCache.saveData(dataCache!)
                            }
                            var arrayRelated = [RelatedAppOBJ]()
                            for obj:JSON  in json["ios"].arrayValue{
                                let relatedAppOBJ = RelatedAppOBJ(json: obj)
                                arrayRelated.append(relatedAppOBJ)
                            }
                            
                            completionBlock(relatedApps: arrayRelated, error: nil)
                        }
                        break
                    case .Failure:
                        completionBlock(relatedApps: nil, error: respone.result.error)
                        break
                    }
                })

            }else{
                let cvdata = cache?.dataCache
                let json = JSON(data: cvdata!)
                var arrayRelated = [RelatedAppOBJ]()
                for obj:JSON  in json["ios"].arrayValue{
                    let relatedAppOBJ = RelatedAppOBJ(json: obj)
                    arrayRelated.append(relatedAppOBJ)
                }
                
                completionBlock(relatedApps: arrayRelated, error: nil)
            }
        }else{
            manager.request(.GET, urlString).responseJSON(completionHandler: { respone in
                switch respone.result{
                case .Success:
                    if let value  = respone.result.value {
                        let json = JSON(value)["data"]
                        let cacheValue = value["cache"] as? Double ?? 0
                        if cacheValue > 0{
                            let dataCache = DataCache.findByID(urlString)
                            dataCache?.urlCache = urlString
                            try! dataCache?.dataCache = json.rawData()
                            dataCache?.addedTime = NSDate().timeIntervalSince1970
                            dataCache?.timeCache = cacheValue
                            DataCache.saveData(dataCache!)
                        }
                        var arrayRelated = [RelatedAppOBJ]()
                        for obj:JSON  in json["ios"].arrayValue{
                            let relatedAppOBJ = RelatedAppOBJ(json: obj)
                            arrayRelated.append(relatedAppOBJ)
                        }
                        
                        completionBlock(relatedApps: arrayRelated, error: nil)
                    }
                    break
                case .Failure:
                    completionBlock(relatedApps: nil, error: respone.result.error)
                    break
                }
            })

        }
    }

    /**
     Lấy country
     */
    static func getCountry(completionBlock: (countries: [StatisticCountry]?, error: NSError?) -> Void) {
        let urlString = "http://v2.live3s.com/m3m12k443m1n311/country-\(AL0604.currentLanguage).js"
        let cache = DataCache.findByID(urlString)
        if cache?.urlCache != "" {
            // het thoi gian cache
            let time = Double((cache?.addedTime)!) + Double((cache?.timeCache)!)
            let time2 = NSDate().timeIntervalSince1970
            if time < time2 {
                manager.request(.GET, urlString).responseJSON(completionHandler: { respone in
                    switch respone.result{
                    case .Success:
                        if let value  = respone.result.value {
                            let json = JSON(value)["data"].array
                            let cacheValue = value["cache"] as? Double ?? 0
                            if cacheValue > 0{
                                let dataCache = DataCache.findByID(urlString)
                                dataCache?.urlCache = urlString
                                try! dataCache?.dataCache = JSON(value)["data"].rawData()
                                dataCache?.addedTime = NSDate().timeIntervalSince1970
                                dataCache?.timeCache = cacheValue
                                DataCache.saveData(dataCache!)
                            }
                            var arrayCountries = [StatisticCountry]()
                            if let data = json {
                                for countryJson:JSON in data {
                                    let country = StatisticCountry(json: countryJson)
                                    arrayCountries.append(country)
                                }
                                
                            }
                            
                            completionBlock(countries: arrayCountries, error: nil)
                        }
                        break
                    case .Failure:
                        completionBlock(countries: nil, error: respone.result.error)
                        break
                    }
                })

            }else{
                let cvdata = cache?.dataCache
                let json = JSON(data: cvdata!).array
                var arrayCountries = [StatisticCountry]()
                if let data = json {
                    for countryJson:JSON in data {
                        let country = StatisticCountry(json: countryJson)
                        arrayCountries.append(country)
                    }
                    
                }
                
                completionBlock(countries: arrayCountries, error: nil)

            }
        }else{
            manager.request(.GET, urlString).responseJSON(completionHandler: { respone in
                switch respone.result{
                case .Success:
                    if let value  = respone.result.value {
                        let json = JSON(value)["data"].array
                        let cacheValue = value["cache"] as? Double ?? 0
                        if cacheValue > 0{
                            let dataCache = DataCache.findByID(urlString)
                            dataCache?.urlCache = urlString
                            try! dataCache?.dataCache = JSON(value)["data"].rawData()
                            dataCache?.addedTime = NSDate().timeIntervalSince1970
                            dataCache?.timeCache = cacheValue
                            DataCache.saveData(dataCache!)
                        }
                        var arrayCountries = [StatisticCountry]()
                        if let data = json {
                            for countryJson:JSON in data {
                                let country = StatisticCountry(json: countryJson)
                                arrayCountries.append(country)
                            }
                            
                        }
                        
                        completionBlock(countries: arrayCountries, error: nil)
                    }
                    break
                case .Failure:
                    completionBlock(countries: nil, error: respone.result.error)
                    break
                }
            })

        }
    }

    /**
     Lấy giải đấu phổ biến
     */
    static func getCommomLeague(completionBlock: (commomLeagues: [StatisticSession]?, error: NSError?) -> Void) {
        let urlString = "http://v2.live3s.com/m3m12k443m1n311/top-leagues-\(AL0604.currentLanguage).js"
        let cache = DataCache.findByID(urlString)
        if cache?.urlCache != "" {
            // het thoi gian cache
            let time = Double((cache?.addedTime)!) + Double((cache?.timeCache)!)
            let time2 = NSDate().timeIntervalSince1970
            if time < time2 {
                manager.request(.GET, urlString).responseJSON(completionHandler: { respone in
                    switch respone.result{
                    case .Success:
                        if let value  = respone.result.value {
                            let json = JSON(value)["data"].array
                            let cacheValue = value["cache"] as? Double ?? 0
                            if cacheValue > 0{
                                let dataCache = DataCache.findByID(urlString)
                                dataCache?.urlCache = urlString
                                try! dataCache?.dataCache = JSON(value)["data"].rawData()
                                dataCache?.addedTime = NSDate().timeIntervalSince1970
                                dataCache?.timeCache = cacheValue
                                DataCache.saveData(dataCache!)
                            }
                            var arraycommomLeagues = [StatisticSession]()
                            if let data = json {
                                for commomLeagueJson:JSON in data {
                                    let commomLeague = StatisticSession(json: commomLeagueJson)
                                    arraycommomLeagues.append(commomLeague)
                                }
                            }
                            completionBlock(commomLeagues: arraycommomLeagues, error: nil)
                        }
                        break
                    case .Failure:
                        completionBlock(commomLeagues: nil, error: respone.result.error)
                        break
                    }
                })

            }else{
                let cvdata = cache?.dataCache
                let json = JSON(data: cvdata!).array
                var arraycommomLeagues = [StatisticSession]()
                if let data = json {
                    for commomLeagueJson:JSON in data {
                        let commomLeague = StatisticSession(json: commomLeagueJson)
                        arraycommomLeagues.append(commomLeague)
                    }
                }
                completionBlock(commomLeagues: arraycommomLeagues, error: nil)
            }
        }else{
            manager.request(.GET, urlString).responseJSON(completionHandler: { respone in
                switch respone.result{
                case .Success:
                    if let value  = respone.result.value {
                        let json = JSON(value)["data"].array
                        let cacheValue = value["cache"] as? Double ?? 0
                        if cacheValue > 0{
                            let dataCache = DataCache.findByID(urlString)
                            dataCache?.urlCache = urlString
                            try! dataCache?.dataCache = JSON(value)["data"].rawData()
                            dataCache?.addedTime = NSDate().timeIntervalSince1970
                            dataCache?.timeCache = cacheValue
                            DataCache.saveData(dataCache!)
                        }
                        var arraycommomLeagues = [StatisticSession]()
                        if let data = json {
                            for commomLeagueJson:JSON in data {
                                let commomLeague = StatisticSession(json: commomLeagueJson)
                                arraycommomLeagues.append(commomLeague)
                            }
                        }
                        completionBlock(commomLeagues: arraycommomLeagues, error: nil)
                    }
                    break
                case .Failure:
                    completionBlock(commomLeagues: nil, error: respone.result.error)
                    break
                }
            })

        }
    }
    
    // MARK: Tip api 
    static func getTipsData(completion: (tips: [TipsModule]?, error: NSError?) -> ()) {
        let urlString = "http://v2.live3s.com/m3m12k443m1n311/tip-time.js"
        let cache = DataCache.findByID(urlString)
        if cache?.urlCache != "" {
            // het thoi gian cache
            let time = Double((cache?.addedTime)!) + Double((cache?.timeCache)!)
            let time2 = NSDate().timeIntervalSince1970
            if time < time2 {
                manager.request(.GET, urlString).responseJSON(completionHandler: {response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let json = JSON(value)["data"].array
                            let cacheValue = value["cache"] as? Double ?? 0
                            if cacheValue > 0{
                                let dataCache = DataCache.findByID(urlString)
                                dataCache?.urlCache = urlString
                                try! dataCache?.dataCache = JSON(value)["data"].rawData()
                                dataCache?.addedTime = NSDate().timeIntervalSince1970
                                dataCache?.timeCache = cacheValue
                                DataCache.saveData(dataCache!)
                            }
                            var result = [TipsModule]()
                            if let data = json {
                                for tip in data {
                                    let tipModule = TipsModule(json: tip)
                                    result.append(tipModule)
                                }
                            }
                            completion(tips: result, error: nil)
                        }
                    case .Failure:
                        completion(tips: nil, error: response.result.error)
                    }
                })
            }else{
                let cvdata = cache?.dataCache
                let json = JSON(data: cvdata!).array
                var result = [TipsModule]()
                if let data = json {
                    for tip in data {
                        let tipModule = TipsModule(json: tip)
                        result.append(tipModule)
                    }
                }
                completion(tips: result, error: nil)
            }
        }else{
            manager.request(.GET, urlString).responseJSON(completionHandler: {response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)["data"].array
                        let cacheValue = value["cache"] as? Double ?? 0
                        if cacheValue > 0{
                            let dataCache = DataCache.findByID(urlString)
                            dataCache?.urlCache = urlString
                            try! dataCache?.dataCache = JSON(value)["data"].rawData()
                            dataCache?.addedTime = NSDate().timeIntervalSince1970
                            dataCache?.timeCache = cacheValue
                            DataCache.saveData(dataCache!)
                        }
                        var result = [TipsModule]()
                        if let data = json {
                            for tip in data {
                                let tipModule = TipsModule(json: tip)
                                result.append(tipModule)
                            }
                        }
                        completion(tips: result, error: nil)
                    }
                case .Failure:
                    completion(tips: nil, error: response.result.error)
                }
            })
        }
        
    }

    /**
     Lấy Advertising
     */
    static func getAdvertising(completionBlock: (checkUpdateModule: [CheckUpdateModule]?, advertisings: [NSDictionary]?, error: NSError?) -> Void) {
        let urlString = GET_ADVERTISING

            manager.request(.GET, urlString).responseJSON(completionHandler: { respone in
                switch respone.result{
                case .Success:
                    if let value  = respone.result.value {

                        var checkUpdateModules: [CheckUpdateModule] = [CheckUpdateModule]()
                        if let json:JSON = JSON(value)["app"] {
                            let checkUpdateModule = CheckUpdateModule(json: json)
                            checkUpdateModules.append(checkUpdateModule)
                        }
                        var advertisings: [NSDictionary] = [NSDictionary]()
                        if let json = JSON(value)["listads"].dictionary {
                            for (keyAdver,adver):(String,JSON) in json{
                                let advertising = AdModulde(json: adver)
                                let dicAdd:[String:AdModulde] = [keyAdver:advertising]
                                advertisings.append(dicAdd)
                                
                            }
                        }
                        
                        
                        completionBlock(checkUpdateModule: checkUpdateModules, advertisings: advertisings, error: nil)
                    }
                    break
                case .Failure:
                    completionBlock(checkUpdateModule: nil, advertisings: nil, error: respone.result.error)
                    break
                }
            })
    }

    
    /**
     Lấy Lịch thi đấu của giải đấu
     */
    static func getFixturesOfLeague(leagueID: String,completionBlock: (staticMatchModule: [StaticMatchModule]?, error: NSError?) -> Void) {
        let urlString = "http://v2.live3s.com/m3m12k443m1n311/fixtures/\(leagueID)-\(AL0604.currentLanguage).js"
        let cache = DataCache.findByID(urlString)
        if cache?.urlCache != "" {
            // het thoi gian cache
            let time = Double((cache?.addedTime)!) + Double((cache?.timeCache)!)
            let time2 = NSDate().timeIntervalSince1970
            if time < time2 {
                manager.request(.GET, urlString).responseJSON(completionHandler: { respone in
                    switch respone.result{
                    case .Success:
                        if let value  = respone.result.value {
                            let json = JSON(value)["data"].array
                            let cacheValue = value["cache"] as? Double ?? 0
                            if cacheValue > 0{
                                let dataCache = DataCache.findByID(urlString)
                                dataCache?.urlCache = urlString
                                try! dataCache?.dataCache = JSON(value)["data"].rawData()
                                dataCache?.addedTime = NSDate().timeIntervalSince1970
                                dataCache?.timeCache = cacheValue
                                DataCache.saveData(dataCache!)
                            }
                            var result = [StaticMatchModule]()
                            if let data = json {
                                for module in data {
                                    let matchModule = StaticMatchModule(json: module)
                                    result.append(matchModule)
                                }
                            }
                            completionBlock(staticMatchModule: result, error: nil)
                            
                        }
                        break
                    case .Failure:
                        completionBlock(staticMatchModule: nil, error: respone.result.error)
                        break
                    }
                })
 
            }else{
                let cvdata = cache?.dataCache
                let json = JSON(data: cvdata!).array
                var result = [StaticMatchModule]()
                if let data = json {
                    for module in data {
                        let matchModule = StaticMatchModule(json: module)
                        result.append(matchModule)
                    }
                }
                completionBlock(staticMatchModule: result, error: nil)

            }
        }else{
            manager.request(.GET, urlString).responseJSON(completionHandler: { respone in
                switch respone.result{
                case .Success:
                    if let value  = respone.result.value {
                        let cacheValue = value["cache"] as? Double ?? 0
                        if cacheValue > 0{
                            let dataCache = DataCache.findByID(urlString)
                            dataCache?.urlCache = urlString
                            try! dataCache?.dataCache = JSON(value)["data"].rawData()
                            dataCache?.addedTime = NSDate().timeIntervalSince1970
                            dataCache?.timeCache = cacheValue
                            DataCache.saveData(dataCache!)
                        }
                        let json = JSON(value)["data"].array
                        var result = [StaticMatchModule]()
                        if let data = json {
                            for module in data {
                                let matchModule = StaticMatchModule(json: module)
                                result.append(matchModule)
                            }
                        }
                        completionBlock(staticMatchModule: result, error: nil)
                        
                    }
                    break
                case .Failure:
                    completionBlock(staticMatchModule: nil, error: respone.result.error)
                    break
                }
            })
  
        }
    }

    /**
     Lấy Ket qua của giải đấu
     */
    static func getResultOfLeague(leagueID: String,completionBlock: (staticMatchModule: [StaticMatchModule]?, error: NSError?) -> Void) {
        let urlString = "http://v2.live3s.com/m3m12k443m1n311/results/\(leagueID)-\(AL0604.currentLanguage).js"
        let cache = DataCache.findByID(urlString)
        if cache?.urlCache != "" {
            // het thoi gian cache
            let time = Double((cache?.addedTime)!) + Double((cache?.timeCache)!)
            let time2 = NSDate().timeIntervalSince1970
            if time < time2 {
                manager.request(.GET, urlString).responseJSON(completionHandler: { respone in
                    switch respone.result{
                    case .Success:
                        if let value  = respone.result.value {
                            let json = JSON(value)["data"].array
                            let cacheValue = value["cache"] as? Double ?? 0
                            if cacheValue > 0{
                                let dataCache = DataCache.findByID(urlString)
                                dataCache?.urlCache = urlString
                                try! dataCache?.dataCache = JSON(value)["data"].rawData()
                                dataCache?.addedTime = NSDate().timeIntervalSince1970
                                dataCache?.timeCache = cacheValue
                                DataCache.saveData(dataCache!)
                            }
                            var result = [StaticMatchModule]()
                            if let data = json {
                                for module in data {
                                    let matchModule = StaticMatchModule(json: module)
                                    result.append(matchModule)
                                }
                            }
                            completionBlock(staticMatchModule: result, error: nil)
                            
                        }
                        break
                    case .Failure:
                        completionBlock(staticMatchModule: nil, error: respone.result.error)
                        break
                    }
                })

            }else{
                let cvdata = cache?.dataCache
                let json = JSON(data: cvdata!).array
                var result = [StaticMatchModule]()
                if let data = json {
                    for module in data {
                        let matchModule = StaticMatchModule(json: module)
                        result.append(matchModule)
                    }
                }
                completionBlock(staticMatchModule: result, error: nil)
            }
        }else{
            manager.request(.GET, urlString).responseJSON(completionHandler: { respone in
                switch respone.result{
                case .Success:
                    if let value  = respone.result.value {
                        let json = JSON(value)["data"].array
                        let cacheValue = value["cache"] as? Double ?? 0
                        if cacheValue > 0{
                            let dataCache = DataCache.findByID(urlString)
                            dataCache?.urlCache = urlString
                            try! dataCache?.dataCache = JSON(value)["data"].rawData()
                            dataCache?.addedTime = NSDate().timeIntervalSince1970
                            dataCache?.timeCache = cacheValue
                            DataCache.saveData(dataCache!)
                        }
                        var result = [StaticMatchModule]()
                        if let data = json {
                            for module in data {
                                let matchModule = StaticMatchModule(json: module)
                                result.append(matchModule)
                            }
                        }
                        completionBlock(staticMatchModule: result, error: nil)
                        
                    }
                    break
                case .Failure:
                    completionBlock(staticMatchModule: nil, error: respone.result.error)
                    break
                }
            })

        }
    }

    /**
     Lấy Ket qua của giải đấu
     */
    static func getDataForMenu(completionBlock: (menusEN: [MenuModule]?,menusVI: [MenuModule]?,menusFR: [MenuModule]?, error: NSError?) -> Void) {
         let urlString = GET_MENU
        let cache = DataCache.findByID(urlString)
        if cache?.urlCache != "" {
            // het thoi gian cache
            let time = Double((cache?.addedTime)!) + Double((cache?.timeCache)!)
            let time2 = NSDate().timeIntervalSince1970
            if time < time2 {
                manager.request(.GET, urlString).responseJSON(completionHandler: { respone in
                    switch respone.result{
                    case .Success:
                        if let value  = respone.result.value {
                            let json = JSON(value)["data"].dictionary
                            let cacheValue = value["cache"] as? Double ?? 0
                            if cacheValue > 0{
                                let dataCache = DataCache.findByID(urlString)
                                dataCache?.urlCache = urlString
                                try! dataCache?.dataCache = JSON(value)["data"].rawData()
                                dataCache?.addedTime = NSDate().timeIntervalSince1970
                                dataCache?.timeCache = cacheValue
                                DataCache.saveData(dataCache!)
                            }
                            var resultEN = [MenuModule]()
                            var resultVI = [MenuModule]()
                            var resultFR = [MenuModule]()
                            for (key,values):(String, JSON) in json! {
                                if key == "en"{
                                    for value:JSON in values.array!{
                                        let menu = MenuModule(json: value)
                                        resultEN.append(menu)
                                        
                                    }
                                }
                                if key == "vi"{
                                    for value:JSON in values.array!{
                                        let menu = MenuModule(json: value)
                                        resultVI.append(menu)
                                        
                                    }
                                }
                                if key == "fr"{
                                    for value:JSON in values.array!{
                                        let menu = MenuModule(json: value)
                                        resultFR.append(menu)
                                        
                                    }
                                }
                                
                            }
                            
                            completionBlock(menusEN: resultEN,menusVI: resultVI,menusFR: resultFR, error: respone.result.error)
                            
                        }
                        break
                    case .Failure:
                        completionBlock(menusEN: nil,menusVI: nil,menusFR: nil, error: respone.result.error)
                        break
                    }
                })

            }else{
                let cvdata = cache?.dataCache
                let json = JSON(data: cvdata!).dictionary
                var resultEN = [MenuModule]()
                var resultVI = [MenuModule]()
                var resultFR = [MenuModule]()
                for (key,values):(String, JSON) in json! {
                    if key == "en"{
                        for value:JSON in values.array!{
                            let menu = MenuModule(json: value)
                            resultEN.append(menu)
                            
                        }
                    }
                    if key == "vi"{
                        for value:JSON in values.array!{
                            let menu = MenuModule(json: value)
                            resultVI.append(menu)
                            
                        }
                    }
                    if key == "fr"{
                        for value:JSON in values.array!{
                            let menu = MenuModule(json: value)
                            resultFR.append(menu)
                            
                        }
                    }
                    
                }
                
                completionBlock(menusEN: resultEN,menusVI: resultVI,menusFR: resultFR, error: nil)
            }
        }else{
            manager.request(.GET, urlString).responseJSON(completionHandler: { respone in
                switch respone.result{
                case .Success:
                    if let value  = respone.result.value {
                        let json = JSON(value)["data"].dictionary
                        let cacheValue = value["cache"] as? Double ?? 0
                        if cacheValue > 0{
                            let dataCache = DataCache.findByID(urlString)
                            dataCache?.urlCache = urlString
                            try! dataCache?.dataCache = JSON(value)["data"].rawData()
                            dataCache?.addedTime = NSDate().timeIntervalSince1970
                            dataCache?.timeCache = cacheValue
                            DataCache.saveData(dataCache!)
                        }
                        var resultEN = [MenuModule]()
                        var resultVI = [MenuModule]()
                        var resultFR = [MenuModule]()
                        for (key,values):(String, JSON) in json! {
                            if key == "en"{
                                for value:JSON in values.array!{
                                    let menu = MenuModule(json: value)
                                    resultEN.append(menu)
                                    
                                }
                            }
                            if key == "vi"{
                                for value:JSON in values.array!{
                                    let menu = MenuModule(json: value)
                                    resultVI.append(menu)
                                    
                                }
                            }
                            if key == "fr"{
                                for value:JSON in values.array!{
                                    let menu = MenuModule(json: value)
                                    resultFR.append(menu)
                                    
                                }
                            }
                            
                        }
                        
                        completionBlock(menusEN: resultEN,menusVI: resultVI,menusFR: resultFR, error: respone.result.error)
                        
                    }
                    break
                case .Failure:
                    completionBlock(menusEN: nil,menusVI: nil,menusFR: nil, error: respone.result.error)
                    break
                }
            })
 
        }
    }

    //MARK: Standing api - get top score
    
    static func getTopScoreStanding(leagueID: String, completionBlock: (topScores: [TopScoreStandingModule]?, error: NSError?) -> ()) {
        let urlString = "http://v2.live3s.com/m3m12k443m1n311/top-scorers/\(leagueID).js"
            manager.request(.GET, urlString).responseJSON(completionHandler: {response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value).array
                        var result = [TopScoreStandingModule]()
                        if let data = json {
                            for module in data {
                                let topscore = TopScoreStandingModule(json: module)
                                result.append(topscore)
                            }
                        }
                        completionBlock(topScores: result, error: nil)
                    } else {
                        completionBlock(topScores: [TopScoreStandingModule](), error: nil)
                    }
                    break
                case .Failure:
                    completionBlock(topScores: nil, error: response.result.error)
                    break
                }
            })
    }

    //MARK: Get All Language
    
    static func getAllLanguague(completionBlock: (languages: [LanguageModule]?, error: NSError?) -> ()) {
        let urlString = "http://v2.live3s.com/m3m12k443m1n311/lang-all.js"
        let cache = DataCache.findByID(urlString)
        if cache?.urlCache != "" {
            // het thoi gian cache
            let time = Double((cache?.addedTime)!) + Double((cache?.timeCache)!)
            let time2 = NSDate().timeIntervalSince1970
            if time < time2 {
                manager.request(.GET, urlString).responseJSON(completionHandler: {response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let json = JSON(value)["data"].array
                            let cacheValue = value["cache"] as? Double ?? 0
                            if cacheValue > 0{
                                let dataCache = DataCache.findByID(urlString)
                                dataCache?.urlCache = urlString
                                try! dataCache?.dataCache = JSON(value)["data"].rawData()
                                dataCache?.addedTime = NSDate().timeIntervalSince1970
                                dataCache?.timeCache = cacheValue
                                DataCache.saveData(dataCache!)
                            }
                            var result = [LanguageModule]()
                            if let data = json {
                                for module in data {
                                    let languague = LanguageModule(json: module)
                                    result.append(languague)
                                }
                            }
                            completionBlock(languages: result, error: nil)
                        } else {
                            completionBlock(languages: [LanguageModule](), error: nil)
                        }
                        break
                    case .Failure:
                        completionBlock(languages: nil, error: response.result.error)
                        break
                    }
                })
            }else{
                let cvdata = cache?.dataCache
                let json = JSON(data: cvdata!).array
                var result = [LanguageModule]()
                if let data = json {
                    for module in data {
                        let languague = LanguageModule(json: module)
                        result.append(languague)
                    }
                }
                completionBlock(languages: result, error: nil)
            }
        }else{
            
        }
        manager.request(.GET, urlString).responseJSON(completionHandler: {response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)["data"].array
                    let cacheValue = value["cache"] as? Double ?? 0
                    if cacheValue > 0{
                        let dataCache = DataCache.findByID(urlString)
                        dataCache?.urlCache = urlString
                        try! dataCache?.dataCache = JSON(value)["data"].rawData()
                        dataCache?.addedTime = NSDate().timeIntervalSince1970
                        dataCache?.timeCache = cacheValue
                        DataCache.saveData(dataCache!)
                    }
                    var result = [LanguageModule]()
                    if let data = json {
                        for module in data {
                            let languague = LanguageModule(json: module)
                            result.append(languague)
                        }
                    }
                    completionBlock(languages: result, error: nil)
                } else {
                    completionBlock(languages: [LanguageModule](), error: nil)
                }
                break
            case .Failure:
                completionBlock(languages: nil, error: response.result.error)
                break
            }
        })
    }

    //MARK: Standing api - get top score
    
    static func registerPush(status: String, matchID: String, pushType: String,completionBlock: (result: String?, pushType:String,status: String, error: NSError?) -> ()) {
        if let token:String = NotificationService.shareInstance.getDeviceToken(){
            let currentLocale = NSLocale.currentLocale()
            let countryCode = currentLocale.objectForKey(NSLocaleCountryCode)
            let urlString = "http://v3.live3s.com/?c=app&m=push_ios_match&key=m3m12k443m1n311&match_id=\(matchID)&country=\(countryCode)&lang=\(AL0604.currentLanguage)&device=\(token)&os=ios&push_type=\(pushType)&status=\(status)"
            manager.request(.GET, urlString).responseString(completionHandler: {response in
                    if let value = response.result.value {
                        let success = String("\(value)")
                        completionBlock(result: success,pushType: pushType, status: status, error: nil)
                    } else {
                        completionBlock(result: "",pushType: pushType,status: status, error: nil)
                    }
            })
        }

    }
    
    
    /**
     Lấy list channel của trận đấy
     */
    static func getListChannel(matchID: String, completionBlock: (json:JSON, error: NSError?) -> Void ){
        
        let urlString = "http://v2.live3s.com/m3m12k443m1n311/tv-listings/\(matchID).js"
        manager.request(.GET, urlString).responseJSON(completionHandler: { response in
                switch response.result{
                case .Success:
                    if let value  = response.result.value {
                        let json = JSON(value)["data"]
                        completionBlock(json: json, error: nil)
                    }
                    break
                case .Failure:
                    completionBlock(json: nil, error: response.result.error)
                    break
                    
                }
            })
        
    }

    static func ShowAlertCache(){
        let alert = UIAlertController(title:AL0604.localization(LanguageKey.alert), message: "Data frome Cache", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: AL0604.localization(LanguageKey.cancel), style: UIAlertActionStyle.Default, handler: nil))
        let topVC:UIViewController = L3sAppDelegate.topWindow()!
        topVC.presentViewController(alert, animated: true, completion: nil)

    }
    
    static func ShowAlertRequest(){
        let alert = UIAlertController(title:AL0604.localization(LanguageKey.alert), message: "Data frome Server", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: AL0604.localization(LanguageKey.cancel), style: UIAlertActionStyle.Default, handler: nil))
        let topVC:UIViewController = L3sAppDelegate.topWindow()!
        topVC.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
}