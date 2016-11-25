//
//  LanguageModule.swift
//  Live3s
//
//  Created by ATCOMPUTER on 29/05/2016.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON
class LanguageModule {
    var code:String
    var name:String
    var flag:String
    init(json: JSON) {
        self.code = json["code"].stringValue
        self.name = json["name"].stringValue
        self.flag = json["flag"].stringValue
    }
    
}