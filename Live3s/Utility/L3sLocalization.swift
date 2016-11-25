//
//  L3sLocalization.swift
//  Live3s
//
//  Created by phuc on 12/7/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

//MARK: - Localization key
let kLeftMenu_Match = "Match"
let kLeftMenu_Fixtures = "Fixtures"
let kLeftMenu_Result = "Result"
let kLeftMenu_Search = "Search"
let kLeftMenu_Rate = "Rate"
let kLeftMenu_Statistic = "Statistic"
let kLeftMenu_Scheldule = "Scheldule"
let kLeftMenu_LiveTv = "LiveTV"
let kLeftMenu_Tips = "Tips"
let kLeftMenu_Favorite = "Favorite"
let kLeftMenu_Setting = "Setting"
let kLeftMenu_Related = "Related"
let kLeftMenu_Share = "Share"
let kLeftMenu_Review = "Review"

enum SupportLanguage: Int {
    case VietNamese = 1
    case English = 2
    case Franch = 3
}

let AL0604 = L3sLocalization.shareInstance

public class L3sLocalization {
    static let shareInstance = L3sLocalization()
    var currentLanguage:String = "en" {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(currentLanguage, forKey: "kAPP_CURRENT_LANGUAGE")
        }
    }
    
    private let lk = LanguageKey()
    
    init() {
        guard let a = NSUserDefaults.standardUserDefaults().stringForKey("kAPP_CURRENT_LANGUAGE") else {
            currentLanguage = "en"
            return
        }
        currentLanguage = a                
    }
    
    public func localization(key: String) -> String {
        return localization(key, comment: key)
    }
    
    public func localization(key: String, comment: String) -> String {
        guard let defaultRealm = try? Realm(),
        let lang = defaultRealm.objectForPrimaryKey(Language.self, key: currentLanguage)  else {return comment}
        if lang.propertys().contains(key) {
            return lang.valueForKey(key) as? String ?? comment
        } else {
            return comment
        }
    }
    
}
