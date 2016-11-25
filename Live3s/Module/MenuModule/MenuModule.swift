//
//  MenuModule.swift
//  Live3s
//
//  Created by codelover2 on 02/03/2016.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class MenuModule {
    let lang: String
    let name: String
    let module: String
    init(json: JSON) {
        lang = json["lang"].stringValue
        name = json["name"].stringValue
        module = json["module"].stringValue
        
    }
    
    
}