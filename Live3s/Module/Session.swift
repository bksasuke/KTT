//
//  Session.swift
//  Live3s
//
//  Created by phuc on 12/6/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class Session: Hashable {
    var hashValue: Int {
        get {
            return Int(id)!
        }
    }
    static private var filePath:String! {
        let filePath = NSBundle.mainBundle().pathForResource("Session", ofType: "json")
        return filePath!
    }
    static var allSession: [Session] {
        let data = NSData(contentsOfFile: filePath)!
        let sessions = JSON(data: data)
        var result = [Session]()
        for (_, subJson):(String, JSON) in sessions {
            let aSession = Session(dict: subJson)
            result.append(aSession)
        }
        
        return result
    }
    let id: String
    let name: String
    let vi_name: String
    let fr_name: String
    private init(dict: JSON) {
        id = dict["id"].stringValue
        name = dict["name"].stringValue
        vi_name = dict["vi_name"].stringValue
        fr_name = dict["fr_name"].stringValue
    }
    
    static func sessionById(id: String) -> Session? {
        if let index = allSession.indexOf({$0.id == id}) {
            return allSession[index]
        } else {
            return nil
        }
    }
}

func ==(lhs: Session, rhs: Session) -> Bool {
    if lhs.hashValue == rhs.hashValue {
        return true
    } else {
        return false
    }
}