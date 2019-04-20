
import UIKit

extension Date {
  var simpleDate: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d"
    return formatter.string(from: self)
  }
  var simpleTime: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "a"
    var amPm = formatter.string(from: self)
    amPm = String(amPm.characters.first!).lowercased()
    formatter.dateFormat = "h:mm"
    let time = formatter.string(from: self)
    return "\(time)\(amPm)"
  }
  var mediumDate: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium // Dec 25, 2014
    return formatter.string(from: self)
  }
  var yesterday: Date {
    return self.addingTimeInterval(-24 * 60 * 60)
  }
  var tomorrow: Date {
    return self.addingTimeInterval(24 * 60 * 60)
  }
}
