
import Foundation

struct History {
  let days:[Day]
  let summaries: [Summary]
  
  func findSummary(_ dayCount: Int) -> Summary{
    return summaries.filter {
      $0.dayCount == dayCount
      }.first!
  }
  
}

let history = randomData(30)
