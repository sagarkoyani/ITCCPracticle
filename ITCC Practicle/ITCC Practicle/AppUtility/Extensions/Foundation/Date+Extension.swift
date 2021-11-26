//
//  Date+Extension.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

enum DateConvertionType {
    case local, utc, noconversion
}

extension Date {
    var firstDayOfWeek: Date {
        var beginningOfWeek = Date()
        var interval = TimeInterval()
        
        _ = Calendar.current.dateInterval(of: .weekOfYear, start: &beginningOfWeek, interval: &interval, for: self)
        return beginningOfWeek
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        let cal = Calendar.current
        var components = DateComponents()
        components.day = 1
        return cal.date(byAdding: components, to: self.startOfDay)!.addingTimeInterval(-1)
    }
    
    var zeroBasedDayOfWeek: Int? {
        let comp = Calendar.current.component(.weekday, from: self)
        return comp - 1
    }
    
    var percentageOfDay: Double {
        let totalSeconds = self.endOfDay.timeIntervalSince(self.startOfDay) + 1
        let seconds = self.timeIntervalSince(self.startOfDay)
        let percentage = seconds / totalSeconds
        return max(min(percentage, 1.0), 0.0)
    }
    
    var numberOfWeeksInMonth: Int {
        let calendar = Calendar.current
        let weekRange = (calendar as NSCalendar).range(of: NSCalendar.Unit.weekOfYear, in: NSCalendar.Unit.month, for: self)
        
        return weekRange.length
    }
    
    func addWeeks(_ numWeeks: Int) -> Date {
        var components = DateComponents()
        components.weekOfYear = numWeeks
        
        return Calendar.current.date(byAdding: components, to: self)!
    }
    
    func addDays(_ numDays: Int) -> Date {
        var components = DateComponents()
        components.day = numDays
        
        return Calendar.current.date(byAdding: components, to: self)!
    }
    
    func addMinutes(_ numMinutes: Double) -> Date {
        return self.addingTimeInterval(60 * numMinutes)
    }
    
    func weeksAgo(_ numWeeks: Int) -> Date {
        return addWeeks(-numWeeks)
    }
    
    func daysAgo(_ numDays: Int) -> Date {
        return addDays(-numDays)
    }
    
    func addHours(_ numHours: Int) -> Date {
        var components = DateComponents()
        components.hour = numHours
        
        return Calendar.current.date(byAdding: components, to: self)!
    }
    
    func hoursAgo(_ numHours: Int) -> Date {
        return addHours(-numHours)
    }
    
    func minutesAgo(_ numMinutes: Double) -> Date {
        return addMinutes(-numMinutes)
    }
    
    func hoursFrom(_ date: Date) -> Double {
        return Double(Calendar.current.dateComponents([.hour], from: date, to: self).hour!)
    }
    
    func daysBetween(_ date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self.startOfDay, to: date.startOfDay)
        
        return components.day!
    }
    
    func timeAgoSince() -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: self, to: now, options: [])
        
        if let year = components.year, year >= 2 {
            return "\(year)" + " years ago"
        }
        
        if let year = components.year, year >= 1 {
            return "\(year)" + " year ago"
        }
        
        if let month = components.month, month >= 2 {
            return "\(month)" + " months ago"
        }
        
        if let month = components.month, month >= 1 {
            return "\(month)" + " month ago"
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week)" + " weeks ago"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "\(week)" + " week ago"
        }
        
        if let day = components.day, day >= 2 {
            return "\(day)" + " days ago"
        }
        
        if let day = components.day, day >= 1 {
            return "\(day)" + " day ago"
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour)" + " hours ago"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "\(hour)" + " hour ago"
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute)" + " minutes ago"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "\(minute)" + " minute ago"
        }
        
        if let second = components.second, second >= 3 {
            return "\(second)" + " seconds ago"
        }
        
        return "Just now"
    }
    
    //MARK: - convert date to local
    func convertToLocal() -> Date {
        
        let sourceTimeZone = TimeZone(abbreviation: "UTC")
        let destinationTimeZone = TimeZone.current
        
        //calculate interval
        let sourceGMTOffset : Int = (sourceTimeZone?.secondsFromGMT(for: self))!
        let destinationGMTOffset : Int = destinationTimeZone.secondsFromGMT(for:self)
        let interval : TimeInterval = TimeInterval(destinationGMTOffset-sourceGMTOffset)
        
        //set currunt date
        let date: Date = Date(timeInterval: interval, since: self)
        return date
    }
    
    //MARK: - convert date to utc
    func convertToUTC() -> Date {
        
        let sourceTimeZone = TimeZone.current
        let destinationTimeZone = TimeZone(abbreviation: "UTC")
        
        //calc time difference
        let sourceGMTOffset : Int = (sourceTimeZone.secondsFromGMT(for: self))
        let destinationGMTOffset : Int = destinationTimeZone!.secondsFromGMT(for: self)
        let interval : TimeInterval = TimeInterval(destinationGMTOffset-sourceGMTOffset)
        
        //set currunt date
        let date: Date = Date(timeInterval: interval, since: self)
        return date
    }
    
    //MARK: - convert date to another format and string format
    func convertDateFormat(output format: DateFormatter, type: DateConvertionType) -> (String, Date) {
        if type == .utc {
            return (format.string(from: self.convertToUTC()), self)
        } else {
            return (format.string(from: self), self.convertToLocal())
        }
    }
    
    //MARK: - convert date to string
    func toString(style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
}

extension DateFormatter {
    // Static date formatter
    enum Format: String {
        case yyyymmdd = "yyyy-MM-dd"
        case hhmmA    = "hh:mm a"
        case UTCFormat = "yyyy-MM-dd HH:mm:ss"
        case WeekDayhhmma = "EEE,hh:mma"
        case ddMMMyyyy = "dd MMM yyyy"
        case ddMMMyyyyhhmma = "dd MMM yyyy hh:mm a"
        case yyyyMMddTHHmmssSSSZ = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    }
    
    static func `default`(format: Format) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter
    }
}

extension String {
    func toDate(from format: DateFormatter = .default(format: .ddMMMyyyy)) -> Date? {
        return format.date(from: self)
    }
    
    //MARK: - change string date format
    func changeDateFormat(from format: DateFormatter, to outputFormat: DateFormatter, type: DateConvertionType) -> String? {
        return format.date(from: self)?.convertDateFormat(output: outputFormat, type: type).0
    }
}

extension DateFormatter {
    
    private static var dateFormatter = DateFormatter()
    
    class func initWithSafeLocale(withDateFormat dateFormat: String? = nil) -> DateFormatter {
        
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        dateFormatter.calendar = Calendar.init(identifier: .gregorian)
        if let format = dateFormat {
            dateFormatter.dateFormat = format
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        return dateFormatter
    }
}

extension Date {
    var dateFormatted: String {
        let formatter = DateFormatter.initWithSafeLocale(withDateFormat: DateTimeFormater.yyyymmdd.rawValue)
        return  formatter.string(from: self as Date)
    }
}

extension Date {
    var getCurrentDate: String {
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: AppLanguages.english.rawValue)
        dateFormater.dateFormat = DateTimeFormater.yyyymmdd.rawValue
        return dateFormater.string(from: Date())
    }

    var getCurrentTime: String {
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: AppLanguages.english.rawValue)
        dateFormater.dateFormat = DateTimeFormater.HHmm.rawValue
        return dateFormater.string(from: Date())
    }

    var getCurrentTimeUTC: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "MM d, yyyy hh:mm:ss a"
        return dateFormatter.string(from: Date())
    }
    
    func convertAPIDateFormate() -> String {
        let dateFormater = DateFormatter()
//        dateFormater.locale = Locale.init(identifier: AppLanguages.english.rawValue)
        dateFormater.dateFormat = DateTimeFormater.yyyymmdd.rawValue
        return dateFormater.string(from: self)
    }
}

/*
 Examples
 
 print("Date: ", Date())
 print(Date().toString(style: .short))
 let localDate = Date().convertToLocal()
 print(localDate)
 print(localDate.convertToUTC())
 print(Date().convertDateFormat(output: .default(format: .ddMMMyyyyhhmma), type: .utc))

 let getDate = "2021-03-02T13:00:00.208Z".toDate(from: .default(format: .yyyyMMddTHHmmssSSSZ))
 print(getDate ?? Date())
 print(getDate?.toString(style: .medium) ?? "")

 print("2021-03-02T13:00:00.208Z".changeDateFormat(from: .default(format: .yyyyMMddTHHmmssSSSZ), to: .default(format: .ddMMMyyyy), type: .noconversion) ?? Date().toString(style: .short))
 */
