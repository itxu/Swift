
import Foundation

struct Summary {
  
  let dayCount: Int
  let startDate: Date
  let totalRevenue: Double
  let totalGoal: Double
  let totalUnits: Int
  
  var goalProgress: Double {
    return totalRevenue / totalGoal
  }
  
}
