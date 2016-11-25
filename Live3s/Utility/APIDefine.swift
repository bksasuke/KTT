//
//  APIDefine.swift
//  Live3s
//
//  Created by codelover2 on 08/12/2015.
//  Copyright © Năm 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import UIKit

let kGooglePlusClientID = "923375191553-56ek0r6sl93robk9pcu09n7tb8262848.apps.googleusercontent.com"

let HEADER_BACKGROUND_COLOR = UIColor(rgba: "#595758")
let tableViewCellbackgroundCoor = UIColor(rgba: "#f5f5f5")
// Cache = 0
let GET_LIST_LANGUAGE = "http://s3.live3s.com/m3m12k443m1n311/lang.js"

let GET_MENU = "http://v2.live3s.com/m3m12k443m1n311/menu.js"
let GET_MENU_EN = "http://v2.live3s.com/m3m12k443m1n311/menu-en.js"
let GET_MENU_FR = "http://v2.live3s.com/m3m12k443m1n311/menu-fr.js"
let GET_MENU_VI = "http://v2.live3s.com/m3m12k443m1n311/menu-vi.js"

// Lấy tất cả giải đấu
let GET_ALL_LUAGUE = "http://v2.live3s.com/m3m12k443m1n311/league.js"

// Lấy tât cả các trân đấu ngày hiện tại
let GET_ALL_BY_LUAGUE = "http://v2.live3s.com/m3m12k443m1n311/livescore-season.js"
let GET_ALL_BY_TIME = "http://v2.live3s.com/m3m12k443m1n311/livescore-time.js"

// Lấy tât cả các trận chưa đấu ngày hiện tại
let GET_FIXTURES_BY_LUAGUE = "http://v2.live3s.com/m3m12k443m1n311/fixtures-season.js"
let GET_FIXTURES_BY_SORTEDTIME = "http://v2.live3s.com/m3m12k443m1n311/fixtures-time.js"

// Lấy tất cả các trận đã đấu ngày hiện tại
let GET_RESULT_BY_LUAGUE = "http://v2.live3s.com/m3m12k443m1n311/results-season.js"
let GET_RESULT_BY_SORTEDTIME = "http://v2.live3s.com/m3m12k443m1n311/results-time.js"

// Lấy tỉ lệ ngày hiện tại
let GET_RATE_BY_LUAGUE = "http://v2.live3s.com/m3m12k443m1n311/odds-season.js"
let GET_RATE_BY_SORTEDTIME = "http://v2.live3s.com/m3m12k443m1n311/odds-time.js"

// Lấy tât cả các trận live ngày hiện tại

let GET_LIVE_BY_LUAGUE = "http://v2.live3s.com/m3m12k443m1n311/livescore-live-season.js"
let GET_LIVE_BY_SORTEDTIME = "http://v2.live3s.com/m3m12k443m1n311/livescore-live-time.js"

//***Dùng chung cho Livescore, fixtures and resuld - truyền thêm date format: dd-mm-yyyy***
let GET_ALl_FOLLOW_DAY_BY_LUAGUE = "http://v3.live3s.com/?c=app&m=livescore_season&key=m3m12k443m1n311&date="
let GET_ALl_FOLLOW_DAY_BY_SORTEDTIME = "http://v3.live3s.com/?c=app&m=livescore_time&key=m3m12k443m1n311&date="

//truyền thêm date format: dd-mm-yyyy
let GET_RATE_FOLLOW_DAY_BY_LUAGUE = "http://v3.live3s.com/?c=app&m=odds_season&key=m3m12k443m1n311&date="
let GET_RATE_FOLLOW_DAY_BY_SORTEDTIME = "http://v3.live3s.com/?c=app&m=odds_time&key=m3m12k443m1n311&date="

// Truyền thêm match id
let GET_MATCHDETAIL_FINISH_EVENT = "http://v3.live3s.com/?c=app&m=match_events&key=m3m12k443m1n311&match_id="
let GET_MATCHDETAIL_EVENT = "http://v2.live3s.com/m3m12k443m1n311/match-events/"

// Truyền thêm luague id
let ADD_LUAGUE_FAVORITE = "http://s1.live3s.com/?c=app&m=add_fav_league&key=m3m12k443m1n311&device=ksdkkkwkkk3AKKD&league_id="
let REMOVE_LUAGUE_FAVORITE = "http://s1.live3s.com/?c=app&m=del_fav_league&key=m3m12k443m1n311&device=ksdkkkwkkk3AKKD&league_id="

let GET_LIST_LUAGUE_FAVORITE = "http://s1.live3s.com/?c=app&m=get_fav_league&key=m3m12k443m1n311&device=ksdkkkwkkk3AKKD"

let LOG_DEVICE = "http://s1.live3s.com/?c=app&m=ios&key=m3m12k443m1n311&device=ksdkkkwkkk3AKKD"


// Phong độ gần đây và đối đầu
let GET_PLAYING_MATCH_STATICS_URL = "http://v3.live3s.com/?c=app&m=match_h2h&key=m3m12k443m1n311&id="
let GET_MATCH_STATICS_URL = "http://v3.live3s.com/?c=app&m=match_h2h&key=m3m12k443m1n311&id="


// Lấy bang xếp hạng của giải đấu(+ id giải đấu + .js)
let GET_BXH_OF_LEAGUE = "http://v2.live3s.com/m3m12k443m1n311/standings/"

// Get Country
let GET_ALL_COUNTRY = "http://v2.live3s.com/m3m12k443m1n311/country.js"

// Lấy giải đấu của một quốc gia (+ id quốc gia + .js)

let GET_LEAGUES_OF_COUNTRY = "http://v2.live3s.com/m3m12k443m1n311/country/"

// Lấy giải đấu phổ biến
let GET_GENERAL_LEAGUES = "http://v2.live3s.com/m3m12k443m1n311/top-leagues.js"

// API Update match
let API_UPDATE_MATCH = "http://s3.live3s.com/m3m12k443m1n311/livescore-full.txt"

// API TV Guide
let API_TV_GUIDE = "http://v2.live3s.com/m3m12k443m1n311/matchtv-season.js"

// API_LIVE_TV
let API_LIVE_TV = "http://v2.live3s.com/m3m12k443m1n311/livetv-season.js"
// API get link rate app
let GET_LINK_RATE_APP = "http://v2.live3s.com/m3m12k443m1n311/rate-app.js"

// API get releated app
let GET_RELATED_APP = "http://v2.live3s.com/m3m12k443m1n311/ads-apps.js"

// API Get tip
let GET_TIP = "http://v2.live3s.com/m3m12k443m1n311/tip-time.js"

// API Get advertising
let GET_ADVERTISING = "http://dotrongnghia.com/live3s/admob-ios.txt"

// Lây lịch thi đấu của giải đâu ( + id giải đáu + .js)
let GET_FIXTURES_OF_LEAGUE = "http://v2.live3s.com/m3m12k443m1n311/fixtures/"

// Lây ket qua của giải đâu ( + id giải đáu + .js)
let GET_RESULT_OF_LEAGUE = "http://v2.live3s.com/m3m12k443m1n311/results/"


typealias CancelableTask = (cancel: Bool) -> Void

//MARK: - method

func delay(time: NSTimeInterval, work: dispatch_block_t) -> CancelableTask? {
    
    var finalTask: CancelableTask?
    
    let cancelableTask: CancelableTask = { cancel in
        if cancel {
            finalTask = nil // key
            
        } else {
            dispatch_async(dispatch_get_main_queue(), work)
        }
    }
    
    finalTask = cancelableTask
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
        if let task = finalTask {
            task(cancel: false)
        }
    }
    
    return finalTask
}

