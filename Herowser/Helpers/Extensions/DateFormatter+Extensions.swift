//
//  DateFormatter+Extensions.swift
//  Herowser
//
//  Created by Egemen Ayhan on 27.06.2022.
//

import Foundation

public extension DateFormatter {

    static let serverFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()

    /// The default date formatter object. Used for common date operations to prevent re-creations.
    static let defaultFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.gmt0
        return formatter
    }()

    /// Localized formatter, it's locale depends on current language
    static var localizedFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = .languageBasedLocale
        formatter.timeZone = TimeZone.gmt0
        return formatter
    }
}

public enum DateToStringFormat: String {

    /// "yyyy MM dd"
    case yyyyMMdd = "yyyy MM dd"

    /// "MMMM yyyy"
    case MMMMyyyy = "MMMM yyyy"

    /// "HH:mm:ss"
    case HHmmss = "HH:mm:ss"

    /// "yyyy MM dd HH:mm:ss"
    case yyyyMMddHHmmss = "yyyy MM dd HH:mm:ss"

    /// "MM dd yyyy"
    case MMddyyyy = "MM dd yyyy"

    /// "dd-MM-yyyy"
    case ddMMyyyyDashed = "dd-MM-yyyy"

    /// "dd / MM / yyyy"
    case ddMMyyyySlashed = "dd / MM / yyyy"

    /// "dd . MM . yyyy"
    case ddMMyyyyDotted = "dd . MM . yyyy"

    /// "MMMM dd, yyyy"
    case MMMMddyyyy = "MMMM dd, yyyy"

    /// "MMM dd yyyy"
    case MMMddyyyy = "MMM dd, yyyy"

    /// "MMM d, yyyy"
    case MMMdyyyy = "MMM d, yyyy"

    /// "MM / yy"
    case MMyy = "MM / yy"

    /// "yyyy-MM-dd"
    case yyyyMMddDashed = "yyyy-MM-dd"

    /// "MMM dd"
    case MMMdd = "MMM dd"

    /// "E, MMM d"
    case EMMMd = "E, MMM d"

    /// "yyyy-MM-dd HH:mm:ss"
    case yyyyMMddHHmmssDashed = "yyyy-MM-dd HH:mm:ss"

    case yyyy = "yyyy"
}

public extension String {

    func date(with format: DateToStringFormat) -> Date? {
        let formatter = DateFormatter.defaultFormatter
        formatter.dateFormat = format.rawValue
        return formatter.date(from: self)
    }

    func formatServerTime() -> Date? {
        return DateFormatter.serverFormatter.date(from: self)
    }
}

public extension TimeZone {
    static let gmt0: TimeZone? = TimeZone(abbreviation: "GMT")
}

public extension Date {

    func formatForLogic(with formatValue: DateToStringFormat,
                        timeZone: TimeZone = .current) -> String {

        let formatter = DateFormatter.defaultFormatter
        formatter.dateFormat = formatValue.rawValue
        formatter.locale = Locale(identifier: Locale.current.languageCode ?? "tr")
        formatter.timeZone = TimeZone.gmt0

        let destinationGMTOffset = timeZone.secondsFromGMT(for: self)
        let interval = TimeInterval(destinationGMTOffset)
        let calculatedDate = Date(timeInterval: interval, since: self)

        return formatter.string(from: calculatedDate)
    }

    func formatForDisplay(with formatValue: DateToStringFormat,
                          timeZone: TimeZone = .current) -> String {

        let formatter = DateFormatter.defaultFormatter
        formatter.dateFormat = formatValue.rawValue
        formatter.timeZone = TimeZone.gmt0
        formatter.locale = Locale(identifier: Locale.current.languageCode ?? "tr")

        let destinationGMTOffset = timeZone.secondsFromGMT(for: self)
        let interval = TimeInterval(destinationGMTOffset)
        let calculatedDate = Date(timeInterval: interval, since: self)

        return formatter.string(from: calculatedDate)
    }
}

extension Locale {
    /// Locale depends on current language
    public static var languageBasedLocale: Locale {
        return Locale(identifier: Locale.current.languageCode ?? "tr")
    }
}
