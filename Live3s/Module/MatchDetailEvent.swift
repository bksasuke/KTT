//
//  MatchDetailEvent.swift
//  Live3s
//
//  Created by phuc on 12/10/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON


enum MatchDetailEventKey: String {
    case away_event = "away_event"
    case event_type = "event_type"
    case home_event = "home_event"
    case minute = "minute"
    case score = "score"
}

struct MatchDetailEvent {
    var away_event: String
    var event_type: String
    var home_event: String
    var minute: String
    var score: String
    
    init(dict: JSON) {
        away_event = dict[MatchDetailEventKey.away_event.rawValue].stringValue.removePHPSpaceCode()
        home_event = dict[MatchDetailEventKey.home_event.rawValue].stringValue.removePHPSpaceCode()
        event_type = dict[MatchDetailEventKey.event_type.rawValue].stringValue.removePHPSpaceCode()
        minute = dict[MatchDetailEventKey.minute.rawValue].stringValue.removePHPSpaceCode()
        score = dict[MatchDetailEventKey.score.rawValue].stringValue.removePHPSpaceCode()
    }
}