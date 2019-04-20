
import Foundation

enum LocalCache: String {
  case changeToken, drinkTotal, startDate, subscriptionsSaved
}

class FloData {
  
  let floCal = FloCalendar()
  var startDate = Date()
  var lastDate = Date()
  var drinkTotal = 0
  var elapsedDays: Double {
    return max(1, floCal.numberOfDays(from: startDate, to: Date()))
  }
  var drinkAverage: Double {
    return Double(drinkTotal) / elapsedDays
  }
  
  // MARK: - class singleton
  static let sharedFloData = FloData()
  class func sharedInstance() -> FloData {
    return sharedFloData
  }
  
}
