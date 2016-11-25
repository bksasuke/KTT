//
//  DateManager.swift
//  Live3s
//
//  Created by phuc on 12/8/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import Foundation


class DateManager {
    
    static let shareManager = DateManager()
    private let dateComponent: NSDateComponents = {
        let date = NSDate()
        let unitFlags: NSCalendarUnit = [.Day, .Month, .Year, .Weekday]
        let component = NSCalendar.currentCalendar().components(unitFlags, fromDate: date)
        return component
    }()
    private static let dateFormatter = NSDateFormatter()
    var currentDay: Int {
        return dateComponent.day
    }
    
    var currentMonth: Int {
        return dateComponent.month
    }
    
    var currentYear: Int {
        return dateComponent.year
    }
    
    var daysOfMonth: Int {
        switch dateComponent.month {
        case 1,3,5,7,8,12: return 31
        case 2:
            let year = dateComponent.year
            if year%4 == 0 {
                return 29
            } else {
                return 30
            }
        default:
            return 30
        }
    }
    
    func weakDayFromString(dateString: String) -> String {
        let code = AL0604.currentLanguage
        DateManager.dateFormatter.locale = NSLocale(localeIdentifier: code)
        DateManager.dateFormatter.dateFormat = "dd-MM-yyyy-hh"
        let timeZone = DateManager.dateFormatter.timeZone
        let date = DateManager.dateFormatter.dateFromString(dateString + "-12")?.dateByAddingTimeInterval(Double(timeZone.secondsFromGMT))
        let unitFlags: NSCalendarUnit = [.Day, .Month, .Year, .Weekday]
        let component = NSCalendar(identifier: NSCalendarIdentifierISO8601)!.components(unitFlags, fromDate: date!)
        let weekDay = component.weekday
        let array = DateManager.dateFormatter.shortWeekdaySymbols
        return array[weekDay - 1]
        switch weekDay {
        case 1: return AL0604.localization("Sun")
        case 2: return AL0604.localization("Mon")
        case 3: return AL0604.localization("Tue")
        case 4: return AL0604.localization("Wen")
        case 5: return AL0604.localization("Thus")
        case 6: return AL0604.localization("Fri")
        case 7: return AL0604.localization("Sat")
        default: return ""
        }
    }
    
    func dateFromCompt(dd: Int, MM:Int, yyyy: Int) -> String {
        return "\(dd)-\(MM)-\(yyyy)"
    }
    
    func dateToString(aDate: Double, format: String) -> String {
        let date = NSDate(timeIntervalSince1970: aDate)
        let datFormatter = NSDateFormatter()
        datFormatter.dateFormat = format
        return datFormatter.stringFromDate(date)
    }
    
    func dateComponentFromString(aDate: NSDate, format: String) -> (day: String, month: String, year: String) {
        let datFormatter = NSDateFormatter()
        datFormatter.dateFormat = format
        let dateString = datFormatter.stringFromDate(aDate)
        let components = dateString.componentsSeparatedByString("-")
        return (components[0], components[1], components[2])
    }
    
}