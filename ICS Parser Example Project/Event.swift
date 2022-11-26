import Foundation

/// TODO add documentation
public struct Event {
    public var subComponents: [CalendarComponent] = []
    public var otherAttrs = [String:String]()

    // required
    public var uid: String!
    public var dtstamp: Date!

    // optional
    // public var organizer: Organizer? = nil
    public var location: String?
    public var summary: String?
    public var descr: String?
    // public var class: some enum type?
    public var dtstart: Date?
    public var dtend: Date?

    public init(uid: String? = NSUUID().uuidString, dtstamp: Date? = Date()) {
        self.uid = uid
        self.dtstamp = dtstamp
    }
}

extension Event: CalendarComponent {
    public func toCal() -> [String: String] {
        var str: [String: String] = ["BEGIN":"VEVENT"]

        if let uid = uid {
            str["UID"] = "\(uid)\n"
        }
        if let dtstamp = dtstamp {
            str["DTSTAMP"] = "\(dtstamp.toString())"
        }
        if let summary = summary {
            str["SUMMARY"] = "\((summary.replacingOccurrences(of: #"\n"#, with: " ")).replacingOccurrences(of: #"\,"#, with: ","))"
        }
        if let descr = descr {
            str["DESCRIPTION"] = "\((descr.replacingOccurrences(of: #"\n"#, with: "\n")).replacingOccurrences(of: #"\,"#, with: ","))"
        }
        if let dtstart = dtstart {
            str["DTSTART"] = "\(dtstart.toString())"
        }
        if let dtend = dtend {
            str["DTEND"] = "\(dtend.toString())"
        }

        for (key, val) in otherAttrs {
            str["\(key)"] = "\(val)"
        }

        for component in subComponents {
            str["\(component.toCal())"] = "\(component.toCal())"
        }

        str["END"] = "VEVENT"
        return str
    }
}

extension Event: IcsElement {
    public mutating func addAttribute(attr: String, _ value: String) {
        switch attr {
        case "UID":
            uid = value
        case "DTSTAMP;VALUE=DATE-TIME":
            dtstamp = value.toDate()
        case "DTSTART;VALUE=DATE-TIME":
            dtstart = value.toDate()
        case "DTEND;VALUE=DATE-TIME":
            dtend = value.toDate()
        case "DTSTART;VALUE=DATE":
            dtstart = String("\(value)T050000Z").toDate()
        case "DTEND;VALUE=DATE":
            dtend = String("\(value)T050000Z").toDate()
        // case "ORGANIZER":
        //     organizer
        case "SUMMARY":
            summary = value
        case "DESCRIPTION":
            descr = value
        default:
            otherAttrs[attr] = value
        }
    }
}

extension Event: Equatable { }

public func ==(lhs: Event, rhs: Event) -> Bool {
    return lhs.uid == rhs.uid
}

extension Event: CustomStringConvertible {
    public var description: String {
        return "\(dtstamp.toString()): \(summary ?? "")"
    }
}
