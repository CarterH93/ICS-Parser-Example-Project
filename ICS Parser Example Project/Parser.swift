import Foundation

/// TODO add documentation
internal class Parser {
    let icsContent: [String]

    init(_ ics: [String]) {
        icsContent = ics
    }

    func read() throws -> [Calendar] {
        var completeCal = [Calendar?]()

        // Such state, much wow
        var inCalendar = false
        var currentCalendar: Calendar?
        var inEvent = false
        var currentEvent: Event?
        var inAlarm = false
        var currentAlarm: Alarm?

        for (_ , line) in icsContent.enumerated() {
            //This line is to fix weird Quirk with how the ical data is presented
            let line = line.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).filter{!$0.isEmpty}.joined(separator: "\n")
            //
            switch line {
            case "BEGIN:VCALENDAR":
                inCalendar = true
                currentCalendar = Calendar(withComponents: nil)
                continue
            case "END:VCALENDAR":
                inCalendar = false
                completeCal.append(currentCalendar)
                currentCalendar = nil
                continue
            case "BEGIN:VEVENT":
                inEvent = true
                currentEvent = Event()
                continue
            case "END:VEVENT":
                inEvent = false
                currentCalendar?.append(component: currentEvent)
                currentEvent = nil
                continue
            case "BEGIN:VALARM":
                inAlarm = true
                currentAlarm = Alarm()
                continue
            case "END:VALARM":
                inAlarm = false
                currentEvent?.append(component: currentAlarm)
                currentAlarm = nil
                continue
            default:
                break
            }

            guard let (key, value) = line.toKeyValuePair(splittingOn: ":") else {
                // print("(key, value) is nil") // DEBUG
                continue
            }

            if inCalendar && !inEvent {
                currentCalendar?.addAttribute(attr: key, value)
            }

            if inEvent && !inAlarm {
                currentEvent?.addAttribute(attr: key, value)
            }

            if inAlarm {
                currentAlarm?.addAttribute(attr: key, value)
            }
        }

        return completeCal.compactMap{ $0 }
    }
}
