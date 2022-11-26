import Foundation

/// TODO add documentation
public struct Alarm {
    public var subComponents: [CalendarComponent] = []
    public var otherAttrs = [String:String]()
}

extension Alarm: IcsElement {
    public mutating func addAttribute(attr: String, _ value: String) {
        switch attr { // TODO switch not needed, it'll always be default
            default:
                otherAttrs[attr] = value
        }
    }
}

extension Alarm: CalendarComponent {
    public func toCal() -> [String: String] {
        var str: [String: String] = ["BEGIN":"VALARM"]

        for (key, val) in otherAttrs {
            str["\(key)"] = "\(val)"
        }

        str["END"] = "VALARM"
        return str
    }
}
