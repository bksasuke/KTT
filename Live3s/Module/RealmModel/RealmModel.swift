//
//  File.swift
//  Live3s
//
//  Created by ALWAYSWANNAFLY on 5/27/16.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import RealmSwift

protocol Reflectable {
    func propertys()->[String]
}

extension Reflectable
{
    func propertys()->[String]{
        var s = [String]()
        for c in Mirror(reflecting: self).children
        {
            if let name = c.label{
                s.append(name)
            }
        }
        return s
    }
}



class Language: Object, Reflectable {

    dynamic var id = "en"
    dynamic var oneXtwo = "1x2"
    dynamic var alert = "alert"
    dynamic var all = "All Countries"
    dynamic var away = "Away"
    dynamic var cancel = "Cancel"
    dynamic var chap = "Handicap"
    dynamic var club = "Club"
    dynamic var common = "Top Leagues"
    dynamic var connect_grant = "Internet grant"
    dynamic var data_updating = "data is updating"
    dynamic var detail = "Details"
    dynamic var dismiss = "dismiss"
    dynamic var extra_subject = "Live3s is very good app"
    dynamic var extra_text = "Hey you! Try to use this App. It very good"
    dynamic var face_to_face = "VS"
    dynamic var favorite_my_competitions = "Leagues"
    dynamic var favorite_my_score = "Matches"
    dynamic var first_goals = "1st goal"
    dynamic var fixtures = "Fixtures"
    dynamic var form = "Form"
    dynamic var formation_off = "Official"
    dynamic var formation_sub = "Substitute"
    dynamic var ft = "FT"
    dynamic var goal = "Goal"
    dynamic var home = "Home"
    dynamic var input_search_here = "input search here"
    dynamic var label_total_draw = "D"
    dynamic var label_total_lose = "L"
    dynamic var label_total_match = "MP"
    dynamic var label_total_point = "PT"
    dynamic var label_total_win = "W"
    dynamic var languages = "Languages"
    dynamic var last_five_match = "recent matches"
    dynamic var leagues = "Leagues"
    dynamic var line_up = "Lineups"
    dynamic var load_data_fail = "Data is updating\\nPull down to refresh"
    dynamic var loading = "loading..."
    dynamic var lost_connect = "Internet lost"
    dynamic var match = "Match"
    dynamic var match_cast = "Match Stats"
    dynamic var match_finish = "Finished"
    dynamic var match_not_start = "The match has not started yet"
    dynamic var match_stats = "Match Stats"
    dynamic var no_data = "no data now"
    dynamic var normal = "Normal"
    dynamic var notstart = " "
    dynamic var ok = "Ok"
    dynamic var penalty_goals = "Pen"
    dynamic var player = "Player"
    dynamic var postpone = "PP"
    dynamic var rank = "Table"
    dynamic var reconnect = "reconnect"
    dynamic var result = "Results"
    dynamic var round = "round"
    dynamic var season = "season"
    dynamic var table = "Table"
    dynamic var taixiu = " "
    dynamic var team = "Team"
    dynamic var times = "Time"
    dynamic var tip_free = "Tip FREE"
    dynamic var tip_last_match = "Recent Form"
    dynamic var tip_pick = "Pick"
    dynamic var tip_tip = "Tip"
    dynamic var tip_vip = "Tip VIP"
    dynamic var today = "Today"
    dynamic var top_scorers = "Top scorers"
    dynamic var tv_guide = "TV Coverage Guide"
    dynamic var update_app_title = "We have new version. Please update this app!"
    dynamic var view_more_at_web = "View more at Live3s.com!"
    dynamic var label_goal_for = "F"
    dynamic var label_goal_against = "A"

    override static func primaryKey() -> String {
        return "id"
    }
    
    static func create(input: [String: AnyObject], id: String) {
        let language = Language(value: input)
        language.id = id
        guard let defaultRealm = try? Realm() else {return}
        let _ = try? defaultRealm.write {
            defaultRealm.add(language, update: true)
        }
    }
    
    static func create() {
        let language = Language()        
        guard let defaultRealm = try? Realm() else {return}
        let _ = try? defaultRealm.write {
            defaultRealm.add(language, update: true)
        }
    }
}



class MenuList: Object {
    dynamic var id = "en"
    let menuItem = List<Menu>()
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    static func create(id: String) -> MenuList? {
        guard let defaultRealm = try? Realm() else {return nil}
        defaultRealm.beginWrite()
        let m = MenuList()
        m.id = id
        defaultRealm.add(m, update: true)
        if let _ = try? defaultRealm.commitWrite() {
           return m
        }
        return nil
    }
    
}

class Menu: Object {
    var owner: MenuList!
    dynamic var iconUrl = ""
    dynamic var name = ""
    dynamic var index = 0
    override static func primaryKey() -> String {
        return "name"
    }
    
    static func create(input: [String: AnyObject], owner: MenuList?) {
        guard let defaultRealm = try? Realm(), owner = owner else {return}
        defaultRealm.beginWrite()
        let m = Menu(value: input)
        m.owner = owner
        defaultRealm.add(m, update: true)
        owner.menuItem.append(m)
        let _ = try? defaultRealm.commitWrite()
    }

}

class MatchPushItem: Object {
    var owner: MatchPushList!
    dynamic var name = ""
    dynamic var value = ""
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
    static func create(input: [String: AnyObject], owner: MatchPushList?) {
        guard let defaultRealm = try? Realm(), owner = owner else {return}
        defaultRealm.beginWrite()
        let m = MatchPushItem(value: input)
        m.owner = owner
        defaultRealm.add(m, update: true)
        owner.list.append(m)
        let _ = try? defaultRealm.commitWrite()
    }
}

class MatchPushList: Object {
    dynamic var id = "en"
    let list = List<MatchPushItem>()
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func create(id: String) -> MatchPushList? {
        guard let defaultRealm = try? Realm() else {return nil}
        defaultRealm.beginWrite()
        let m = MatchPushList()
        m.id = id
        defaultRealm.add(m, update: true)
        if let _ = try? defaultRealm.commitWrite() {
            return m
        }
        return nil
    }

}

