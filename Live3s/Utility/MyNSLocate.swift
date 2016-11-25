//
//  MyNSLocate.swift
//  Live3s
//
//  Created by codelover2 on 06/05/2016.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import Foundation

extension NSLocale {
    class func locales1(countryName1 : String) -> String {
        var locales : String = ""
        for localeCode in NSLocale.ISOCountryCodes() {
            let countryName = NSLocale.systemLocale().displayNameForKey(NSLocaleCountryCode, value: localeCode)!
            if countryName1.lowercaseString == countryName.lowercaseString {
                return localeCode as! String
            }
        }
        return locales
    }
    
    
}