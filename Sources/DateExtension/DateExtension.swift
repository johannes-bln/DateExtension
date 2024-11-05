// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI
import Foundation

@available(iOS 13.0, *)

/// An enumeration representing various display modes for date formatting.
/// Each case defines a specific format in which a date can be represented.
///
public enum DateExtensionDisplayMode {
    /// Hours:Minutes:Seconds (e.g. "14:35:50")
    case hhmmss
    
    /// Hours:Minutes (e.g. "14:35")
    case hhmm
    
    /// Minutes:Seconds (e.g. "35:50")
    case mmss
    
    /// Hours:Minutes AM/PM (e.g. "02:35 PM")
    case hhmmAMPM
    
    /// Hours:Minutes:Seconds AM/PM (e.g. "02:35:50 PM")
    case hhmmssAMPM
    
    /// Day.Month.Year (e.g. "31.12.2023")
    case ddMMyyyy
    
    /// Month/Day/Year (e.g. "12/31/2023")
    case MMddyyyy
    
    /// Year-Month-Day (e.g. "2023-12-31")
    case yyyyMMdd
    
    /// Day Month Year in full (e.g. "31 December 2023")
    case ddMMMMyyyy
    
    /// Weekday, Day Month Year in full (e.g. "Sunday, 31 December 2023")
    case EEEEddMMMMyyyy
    
    /// Year-Month-Day Hours:Minutes:Seconds (e.g. "2023-12-31 14:35:50")
    case yyyyMMddHHmmss
    
    /// ISO 8601 (e.g. "2023-12-31T14:35:50Z")
    case yyyyMMddTHHmmssZ
    
    /// Day.Month.Year Hours:Minutes (e.g. "31.12.2023 14:35")
    case ddMMyyyyHHmm
    
    /// Relative (e.g. "today", "yesterday", "2 days ago")
    case relative
    
    /// Unix Timestamp
    case unixTimestamp
    
    /// Custom format
    case custom(String)
    
    /// ISO 8601 with milliseconds (e.g. "2023-12-31T14:35:50.123Z")
    case iso8601
    
    /// RFC 2822 (e.g. "Sun, 31 Dec 2023 14:35:50 +0000")
    case rfc2822
    
    /// RFC 3339 (e.g. "2023-12-31T14:35:50+00:00")
    case rfc3339
    
    /// Year and Month (e.g. "2023-12")
    case yyyyMM
    
    /// Day and Month in full (e.g. "31 December")
    case ddMMMM
}


/// An extension on `String` to provide date parsing and formatting capabilities.
///
@available(iOS 13.0, *)
public extension String {
    
    
    ///   Converts a `String` to a `Date` object based on the provided format.
    ///
    /// - Parameter format: The date format to be used for conversion.
    /// - Returns: A `Date` object if the conversion is successful, otherwise `nil`.
    ///
    func toDate(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.autoupdatingCurrent
        return formatter.date(from: self)
    }

    
    ///   Attempts to detect and convert a `String`  to a `Date` object based on a set of predefined formats.
    ///
    /// - Returns: a `Date` Object if a matching Format is founded, otherwise `nil`.
    ///
    func detectedDate() -> Date? {
        
        let formats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd HH:mm:ss",
            "dd-MM-yyyy HH:mm:ss",
            "yyyy-MM-dd",
            "dd.MM.yyyy",
            "MM/dd/yyyy",
            "dd MMMM yyyy",
            "EEEE, dd MMMM yyyy",
            "HH:mm:ss",
            "HH:mm",
            "hh:mm a",
            "hh:mm:ss a",
            "yyyy-MM",
            "dd MMMM",
            "MMM dd, yyyy",
            "dd MMM yyyy",
            "MM/dd/yy",
            "dd-MM-yy",
            "yyyy/MM/dd",
            "yy/MM/dd",
            "dd/MM/yy",
            "MM-dd-yyyy",
            "EEEE, MMMM dd, yyyy",
            "yyyyMMdd",
            "ddMMyyyy",
            "MMddyyyy",
            "dd.MM.yy",
            "MM.dd.yyyy",
            "yyyy.MM.dd",
            "HH:mm:ss.SSS",
            "yyyy/MM/dd HH:mm:ss",
            "dd-MM-yyyy HH:mm",
            "yyyyMMddHHmmss",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm",
            "EEE, dd MMM yyyy HH:mm:ss Z",
            "yyyy-MM-dd HH:mm",
            "MMMM dd, yyyy",
            "EEE, MMM dd, yyyy",
            "EEE, dd MMM yyyy",
            "dd MMM, yyyy",
            "MMM dd, yyyy HH:mm:ss",
            "MMMM dd",
            "EEEE, MMM dd, yyyy",
            "yyyyMMdd'T'HHmmss",
            "yyyy-MM-dd'T'HH:mm:ss.SSSXXX",
            "yyyy-MM-dd'T'HH:mm:ssXXX",
            "yyyy-MM-dd'T'HH:mmXXX",
            "yyyy-MM-dd HH:mm:ss.SSS",
            "dd/MM/yyyy HH:mm:ss",
            "yyyyMMddHHmmssSSS",
            "EEE, dd MMM yyyy HH:mm:ss",
            "yyyy-MM-dd'T'HHmmss",
            "yyyy-MM-dd HHmmss",
            "dd-MM-yyyy'T'HH:mm:ss",
            "EEEE, dd.MM.yyyy HH:mm:ss",
            "MMMM dd, yyyy HH:mm:ss",
            "yyyy/MM/dd'T'HH:mm:ss.SSS",
            "EEE, dd.MM.yyyy HH:mm",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "EEE, dd.MM.yyyy",
            "dd-MM-yyyy'T'HH:mm",
            "dd.MM.yyyy'T'HH:mm:ss",
            "dd-MM-yyyy'T'HHmmss",
            "dd.MM.yyyy'T'HHmmss",
            "dd-MM-yy HH:mm:ss",
            "yyyy-MM-dd'T'HHmmss.SSS",
            "yyyyMMdd'T'HH:mm:ss.SSSZ",
            "EEEE, MMMM dd, yyyy HH:mm:ss",
            "EEEE, dd MMMM yyyy HH:mm:ss",
            "MMM dd, yyyy HH:mm",
            "MMM dd, yyyy HH:mm:ss.SSS",
            "dd MMMM yyyy HH:mm",
            "EEE, MMM dd, yyyy HH:mm:ss",
            "EEE, dd MMM yyyy HH:mm",
            "yyyyMMdd HH:mm:ss",
            "dd.MM.yy HH:mm:ss",
            "MMM dd, yyyy HH:mm:ss a",
            "MMMM dd, yyyy HH:mm a",
            "yyyy/MM/dd HH:mm",
            "yyyy-MM-dd HH:mm:ssZ",
            "dd/MM/yyyy'T'HH:mm:ss.SSSZ",
            "yyyyMMdd'T'HH:mm:ss.SSSXXX",
            "EEEE, dd.MM.yyyy'T'HH:mm:ss.SSS",
            "MMMM dd yyyy, HH:mm:ss",
            "EEEE, dd MMM yyyy HH:mm:ss.SSS",
            "EEE, MMM dd yyyy HH:mm:ss.SSS",
            "MMM dd yyyy HH:mm:ss.SSS",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "dd.MM.yyyy HH:mm",
            "dd/MM/yyyy HH:mm",
            "dd MMM yyyy HH:mm:ss",
            "dd MMM yyyy HH:mm:ss.SSS",
            "EEE, MMM dd yyyy HH:mm:ss a"
        ]

        
        for format in formats {
            if let date = self.toDate(format: format) {
                return date
            }
        }
        return nil
    }

    
    ///   Formats a detected date string according to the specified display mode.
    ///
    /// - Parameter mode: The `DateExtensionsDisplayMode` to be used for formatting.
    /// - Returns: A formatted date string if the detection and formatting are successful, otherwise the original string.
    ///
    func formattedDate(_ mode: DateExtensionDisplayMode) -> String {
        guard let date = self.detectedDate() else { return self }

        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        
        switch mode {
        case .hhmmss:
            formatter.dateFormat = "HH:mm:ss"
        case .hhmm:
            formatter.dateFormat = "HH:mm"
        case .mmss:
            formatter.dateFormat = "mm:ss"
        case .hhmmAMPM:
            formatter.dateFormat = "hh:mm a"
        case .hhmmssAMPM:
            formatter.dateFormat = "hh:mm:ss a"
        case .ddMMyyyy:
            formatter.dateFormat = "dd.MM.yyyy"
        case .MMddyyyy:
            formatter.dateFormat = "MM/dd/yyyy"
        case .yyyyMMdd:
            formatter.dateFormat = "yyyy-MM-dd"
        case .ddMMMMyyyy:
            formatter.dateFormat = "dd MMMM yyyy"
        case .EEEEddMMMMyyyy:
            formatter.dateFormat = "EEEE, dd MMMM yyyy"
        case .yyyyMMddHHmmss:
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        case .yyyyMMddTHHmmssZ:
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        case .ddMMyyyyHHmm:
            formatter.dateFormat = "dd.MM.yyyy HH:mm"
        case .relative:
            let relativeFormatter = RelativeDateTimeFormatter()
            relativeFormatter.locale = Locale.autoupdatingCurrent
            return relativeFormatter.localizedString(for: date, relativeTo: Date())
        case .unixTimestamp:
            return "\(Int(date.timeIntervalSince1970))"
        case .custom(let customFormat):
            formatter.dateFormat = customFormat
        case .iso8601:
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case .rfc2822:
            formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        case .rfc3339:
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
        case .yyyyMM:
            formatter.dateFormat = "yyyy-MM"
        case .ddMMMM:
            formatter.dateFormat = "dd MMMM"
        }
        
        return formatter.string(from: date)
    }
}
