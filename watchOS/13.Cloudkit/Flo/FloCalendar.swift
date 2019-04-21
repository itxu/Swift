
import Foundation

extension Int {
  func random() -> Int {
    return Int(arc4random_uniform(UInt32(self)))
  }
}

struct FloCalendar {
  let cal = Foundation.Calendar(identifier: .gregorian)
  
  func numberOfDays(from startDate: Date, to endDate: Date) -> Double {
    let diffComponents = cal.dateComponents([.day, .hour, .minute], from: startDate, to: endDate)
    if let days = diffComponents.day, let hours = diffComponents.hour, let minutes = diffComponents.minute {
      return Double(days) + Double(hours) / 24.0 + Double(minutes) / 1440.0
    }
    return 0.0
  }
  
  func formattedShort(_ date: Date) -> String {
    return DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short)
  }
  
}
