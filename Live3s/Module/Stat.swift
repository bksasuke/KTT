//
//  Stat.swift
//  Live3s
//
//  Created by phuc on 12/12/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

//let statKeys = ["First Substitution", "First Yellow Card", "Last Substitution", "Last Yellow Card"]
let statKeys: [String] = []
struct Stat {
    let statsName: String
    let homeValue: String
    let awayValue: String
    let homePercent: String
    let awayPercent: String    
    
    init(json: JSON) {
        let prefix = "\(AL0604.currentLanguage)_"
        let statNameKey = prefix+"stats"
        if let statname = json[statNameKey].string {
            statsName = statname
        } else {
            statsName = json["stats"].stringValue
        }
        homeValue = json["home_value"].stringValue
        awayValue = json["away_value"].stringValue
        var iHomeValue:Int
        var iAwayValue:Int
        
        if homeValue.rangeOfString("%") != nil{
            let strCut = homeValue.stringByReplacingOccurrencesOfString("%", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            iHomeValue = Int(strCut)!
        }else {
            if let hp  = Int(homeValue){
                iHomeValue = hp
            }else{
                iHomeValue = 0
            }
        }
        
        if awayValue.rangeOfString("%") != nil{
            let strCut = awayValue.stringByReplacingOccurrencesOfString("%", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            iAwayValue = Int(strCut)!
        }else {
            if let ap = Int(awayValue){
                iAwayValue = ap
                
            }else{
                iAwayValue = 0
            }
        }
        

       
        if iAwayValue == 0 && iHomeValue == 0 {

            homePercent = "0"
            awayPercent = "0"
        }else {
            let totalValue = iHomeValue + iAwayValue
            
            if totalValue > 100  {
                let iHomPersen = Float((1000 / totalValue) * iHomeValue)
                let iAwayPersen = Float((1000 / totalValue) * iAwayValue)
                 homePercent = String(format: "%.3f", iHomPersen/1000)
                awayPercent =  String(format: "%.3f", iAwayPersen/1000)
            }else{
                let iHomPersen = Float((100 / totalValue) * iHomeValue)
                let iAwayPersen = Float((100 / totalValue) * iAwayValue)
                 homePercent = String(format: "%.2f", iHomPersen/100)
                awayPercent =  String(format: "%.2f", iAwayPersen/100)
            }
           
            
        }
        
    }
    
}