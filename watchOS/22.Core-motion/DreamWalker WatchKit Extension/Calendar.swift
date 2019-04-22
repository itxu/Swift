
import Foundation

struct Calendar {
  let secondsPerHour: TimeInterval = 3600
  let cal = Foundation.Calendar(identifier: .gregorian)
//  let cal = Foundation.Calendar(calendarIdentifier: Calendar.Identifier.gregorian)!

  var now: Date {
    return Date()
  }
  
  var startOfToday: Date {
    return cal.startOfDay(for: now)
  }
  
  func startOfNextDay(_ date: Date) -> Date {
    // allow for daylight-saving and crossing a few time zones
    let nextDay = date.addingTimeInterval(secondsPerHour * 28)
    return cal.startOfDay(for: nextDay)
  }
  
  func isDate(_ date1: Date, afterDate date2: Date) -> Bool {
    return date1.timeIntervalSince(date2) > 0
  }
  
}
