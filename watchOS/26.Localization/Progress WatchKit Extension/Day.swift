
import Foundation

struct Day {
  let date: Date
  let status: Double
  let goal: Double
  let units: Int
  
  var averageSellingPrice: Double {
    return status / Double(units)
  }
  
  
}
