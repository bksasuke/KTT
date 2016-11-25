//
//  RelatedAppOBJ.swift
//  Live3s
//
//  Created by codelover2 on 21/01/2016.
//  Copyright © Năm 2016 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class RelatedAppOBJ {
    let icon: String
    let link: String
    let name: String
    init(json: JSON) {
        icon = json["icon"].stringValue
        link = json["link"].stringValue
        name = json["name"].stringValue
        
    }
    
    
}