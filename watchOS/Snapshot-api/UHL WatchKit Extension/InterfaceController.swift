import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
  
  @IBOutlet var teamLogo: WKInterfaceImage!
  @IBOutlet var teamNameLabel: WKInterfaceLabel!
  @IBOutlet var nextMatchLabel: WKInterfaceLabel!
  @IBOutlet var recordLabel: WKInterfaceLabel!
  @IBOutlet var scheduleButton: WKInterfaceButton!
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    
  }
  
  override func willActivate() {
    super.willActivate()
    
    teamNameLabel.setText(ourTeam.name)
    teamLogo.setImageNamed(ourTeam.logoName)
    
    if let nextMatch = season.upcomingMatches.first {
      nextMatchLabel.setText("\(nextMatch.date.simpleDate) @ \(nextMatch.date.simpleTime)")
    } else {
      scheduleButton.setHidden(true)
    }
    
    recordLabel.setText("\(season.record)")
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
    
  }
  

}
