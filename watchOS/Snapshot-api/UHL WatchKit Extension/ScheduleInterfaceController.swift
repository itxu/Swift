
import WatchKit
import Foundation


class ScheduleInterfaceController: WKInterfaceController {
  
  @IBOutlet var table: WKInterfaceTable!
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    
    let upcomingMatches = season.upcomingMatches
    
    table.setNumberOfRows(upcomingMatches.count, withRowType: "ScheduleRowType")
    
    for (index, match) in upcomingMatches.enumerated() {
      updateRow(at: index, with: match)
    }
    
  }
  
  override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
    return rowIndex
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
  func updateRow(at index: Int, with match: Match) {
    guard let row = table.rowController(at: index) as? ScheduleRow else {
      return
    }
    row.opponentLabel.setText(match.opponent.name)
    row.dateLabel.setText("\(match.date.simpleDate) @ \(match.date.simpleTime)")
    row.opponentLogo.setImageNamed(match.opponent.logoName)
  }
  
  @IBAction func addButtonPressed() {
    let match = Match(on: Date().tomorrow)
    season.matches.append(match)
    let matchIndex = season.upcomingMatches.index(of: match)!
    table.insertRows(at: [matchIndex], withRowType: "ScheduleRowType")
    updateRow(at: matchIndex, with: match)
  }
  
  @IBAction func removeButtonPressed() {
    guard let match = season.upcomingMatches.first, let matchIndex = season.matches.index(of: match) else {
      return
    }
    season.matches.remove(at: matchIndex)
    table.removeRows(at: [0])
  }
}
