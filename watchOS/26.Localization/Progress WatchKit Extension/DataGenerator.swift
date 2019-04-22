
import Foundation

func randomData(_ numDays: Int) -> History {
  
  let goal: Double = 7500
  
  var days = [Day]()
  
  var summaries = [Summary]()
  
  var totalRevenue: Double = 0
  
  var totalGoal: Double = 0
  
  var totalUnits: Int = 0
  
  for i in 0..<numDays {
    
    let date = Date().addingTimeInterval(TimeInterval(-60*60*24*i))
    let modifierAmount = 0.4
    let randomModifier = Double(arc4random_uniform(UInt32(goal * modifierAmount)))
    let status = (goal * ( 1 - modifierAmount)) + randomModifier
    let units = Int(arc4random_uniform(UInt32(status)))
    let day = Day(date: date, status: status, goal: goal, units: units)
    days.append(day)
    totalRevenue += status
    totalGoal += goal
    totalUnits += units
    
    if i == 0 || i == 6 || i == 29 {
      let summary = Summary(dayCount: i + 1, startDate: date, totalRevenue: totalRevenue, totalGoal: totalGoal, totalUnits: totalUnits)
      summaries.append(summary)
    }
    
  }
  
  return History(days: days, summaries: summaries)
  
}

