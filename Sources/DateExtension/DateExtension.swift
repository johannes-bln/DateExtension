import Foundation

@available(iOS 13.0, *)
public enum DateExtensionDisplayMode {
    case hhmmss
    case hhmm
    case mmss
    case hhmmAMPM
    case hhmmssAMPM
    case ddMMyyyy
    case MMddyyyy
    case yyyyMMdd
    case ddMMMMyyyy
    case EEEEddMMMMyyyy
    case yyyyMMddHHmmss
    case yyyyMMddTHHmmssZ
    case ddMMyyyyHHmm
    case relative
    case unixTimestamp
    case custom(String)
    case iso8601
    case rfc2822
    case rfc3339
    case yyyyMM
    case ddMMMM
}

@available(iOS 13.0, *)
public extension String {
    /// Converts a `String` to a `Date` using the supplied format string.
    func toDate(format: String) -> Date? {
        DateParser.shared.parse(self, format: format)
    }

    /// Detects many common date/time representations and converts them to `Date`.
    func detectedDate() -> Date? {
        DateParser.shared.detect(self)
    }

    /// Formats a detected date string according to the supplied display mode.
    /// Returns the original string when no date could be detected.
    func formattedDate(_ mode: DateExtensionDisplayMode) -> String {
        guard let date = detectedDate() else { return self }
        return DateFormatterFactory.shared.string(from: date, mode: mode)
    }
}

@available(iOS 13.0, *)
private final class DateParser {
    static let shared = DateParser()

    private init() {}

    private let knownFormats: [String] = [
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

    func parse(_ value: String, format: String) -> Date? {
        let candidate = normalized(value)
        guard !candidate.isEmpty else { return nil }

        let formatter = DateFormatterFactory.shared.formatter(for: format)
        return formatter.date(from: candidate)
    }

    func detect(_ value: String) -> Date? {
        let candidate = normalized(value)
        guard !candidate.isEmpty else { return nil }

        if let unixDate = parseUnixTimestamp(candidate) {
            return unixDate
        }

        if let isoDate = parseISO8601(candidate) {
            return isoDate
        }

        for format in knownFormats where !format.isEmpty {
            let formatter = DateFormatterFactory.shared.formatter(for: format)
            if let date = formatter.date(from: candidate) {
                return date
            }
        }

        return nil
    }

    private func normalized(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func parseUnixTimestamp(_ value: String) -> Date? {
        guard value.allSatisfy({ $0.isNumber || $0 == "." || $0 == "-" }) else {
            return nil
        }

        guard let numeric = Double(value) else { return nil }

        let seconds: Double
        switch value.replacingOccurrences(of: "-", with: "").count {
        case 13:
            seconds = numeric / 1000
        case 16:
            seconds = numeric / 1_000_000
        default:
            seconds = numeric
        }

        return Date(timeIntervalSince1970: seconds)
    }

    private func parseISO8601(_ value: String) -> Date? {
        for formatter in ISO8601FormatterFactory.shared.formatters {
            if let date = formatter.date(from: value) {
                return date
            }
        }
        return nil
    }
}

@available(iOS 13.0, *)
private final class DateFormatterFactory {
    static let shared = DateFormatterFactory()

    private let cache = NSCache<NSString, DateFormatter>()
    private let lock = NSLock()

    private init() {
        cache.countLimit = 256
    }

    func formatter(for format: String) -> DateFormatter {
        lock.lock()
        defer { lock.unlock() }

        if let cached = cache.object(forKey: format as NSString) {
            return cached
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.dateFormat = format

        cache.setObject(formatter, forKey: format as NSString)
        return formatter
    }

    func string(from date: Date, mode: DateExtensionDisplayMode) -> String {
        switch mode {
        case .relative:
            return relativeString(for: date)
        case .unixTimestamp:
            return String(Int(date.timeIntervalSince1970))
        case .custom(let customFormat):
            return formatter(for: customFormat).string(from: date)
        case .iso8601:
            return ISO8601FormatterFactory.shared.milliseconds.string(from: date)
        case .hhmmss:
            return formatter(for: "HH:mm:ss").string(from: date)
        case .hhmm:
            return formatter(for: "HH:mm").string(from: date)
        case .mmss:
            return formatter(for: "mm:ss").string(from: date)
        case .hhmmAMPM:
            return formatter(for: "hh:mm a").string(from: date)
        case .hhmmssAMPM:
            return formatter(for: "hh:mm:ss a").string(from: date)
        case .ddMMyyyy:
            return formatter(for: "dd.MM.yyyy").string(from: date)
        case .MMddyyyy:
            return formatter(for: "MM/dd/yyyy").string(from: date)
        case .yyyyMMdd:
            return formatter(for: "yyyy-MM-dd").string(from: date)
        case .ddMMMMyyyy:
            return formatter(for: "dd MMMM yyyy").string(from: date)
        case .EEEEddMMMMyyyy:
            return formatter(for: "EEEE, dd MMMM yyyy").string(from: date)
        case .yyyyMMddHHmmss:
            return formatter(for: "yyyy-MM-dd HH:mm:ss").string(from: date)
        case .yyyyMMddTHHmmssZ:
            return formatter(for: "yyyy-MM-dd'T'HH:mm:ssZ").string(from: date)
        case .ddMMyyyyHHmm:
            return formatter(for: "dd.MM.yyyy HH:mm").string(from: date)
        case .rfc2822:
            return formatter(for: "EEE, dd MMM yyyy HH:mm:ss Z").string(from: date)
        case .rfc3339:
            return formatter(for: "yyyy-MM-dd'T'HH:mm:ssXXX").string(from: date)
        case .yyyyMM:
            return formatter(for: "yyyy-MM").string(from: date)
        case .ddMMMM:
            return formatter(for: "dd MMMM").string(from: date)
        }
    }

    private func relativeString(for date: Date) -> String {
#if canImport(UIKit) || canImport(AppKit) || canImport(WatchKit)
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        return formatter.localizedString(for: date, relativeTo: Date())
#else
        let interval = Int(date.timeIntervalSinceNow)
        if abs(interval) < 60 { return "now" }
        let minutes = interval / 60
        if abs(minutes) < 60 { return "\(abs(minutes)) min" }
        let hours = minutes / 60
        if abs(hours) < 24 { return "\(abs(hours)) h" }
        let days = hours / 24
        return "\(abs(days)) d"
#endif
    }
}

@available(iOS 13.0, *)
private final class ISO8601FormatterFactory {
    static let shared = ISO8601FormatterFactory()

    let milliseconds: ISO8601DateFormatter
    let formatters: [ISO8601DateFormatter]

    private init() {
        let withMilliseconds = ISO8601DateFormatter()
        withMilliseconds.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        withMilliseconds.timeZone = TimeZone(secondsFromGMT: 0)

        let internetDateTime = ISO8601DateFormatter()
        internetDateTime.formatOptions = [.withInternetDateTime]
        internetDateTime.timeZone = TimeZone(secondsFromGMT: 0)

        let basicDateTime = ISO8601DateFormatter()
        basicDateTime.formatOptions = [.withFullDate, .withTime, .withColonSeparatorInTime, .withDashSeparatorInDate]
        basicDateTime.timeZone = TimeZone(secondsFromGMT: 0)

        self.milliseconds = withMilliseconds
        self.formatters = [withMilliseconds, internetDateTime, basicDateTime]
    }
}
