//
//  AdModule.swift
//  Live3s
//
//  Created by codelover2 on 02/02/2016.
//  Copyright © Năm 2016 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class AdModulde {
    let size: String
    let id: String
    let visible: String
    let rate: String
    init(json: JSON) {
        self.size = json["size"].stringValue
        self.id = json["id"].stringValue
        self.visible = json["visible"].stringValue
        self.rate = json["rate"].stringValue
    }

    
}