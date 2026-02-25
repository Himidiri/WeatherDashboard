//
//  DateFormatter.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import Foundation

class DateFormatterUtils {
    
    static let shared: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return dateFormatter
    }()
    
    static let shortDateFormat: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }()
    
    static let timeFormat: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter
    }()
    
    static let customFormat: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()
    
    static func formattedDate(from timestamp: Int, format: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    static func formattedCurrentDate(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: Date())
    }
    
    static func formattedDateWithStyle(from timestamp: Int, style: DateFormatter.Style) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: date)
    }
    
    static func formattedDate12Hour(from timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    static let time24HHmm: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_GB")
        df.dateFormat = "HH:mm"
        return df
    }()
    
    static func formattedTime24HHmm(from timestamp: Int) -> String {
        time24HHmm.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }
    
    static func formattedDateWithDay(from timestamp: TimeInterval) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh a E"
        let dateString = dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
        return dateString
    }
    
    static func formattedDateWithWeekdayAndDay(from timestamp: TimeInterval) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd"
        return dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
    }
    
    static func formattedDateTime(from timestamp: TimeInterval) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy 'at' h a"
        return dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
    }
    
    static func formattedVisitedPlaceDateTime(from timestamp: TimeInterval) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy 'at' h:mm:ss a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
    }
}

