//
//  CheckUpdateModule.swift
//  Live3s
//
//  Created by codelover2 on 02/02/2016.
//  Copyright © Năm 2016 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class CheckUpdateModule{
    let app_version: String
    let must_update: String
    let link: String
    init(json: JSON) {
        self.app_version = json["app-version"].stringValue
        self.must_update = json["must-update"].stringValue
        self.link = json["link"].stringValue
    }
    
    
}