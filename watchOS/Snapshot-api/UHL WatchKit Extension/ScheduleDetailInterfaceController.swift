
import WatchKit
import Foundation


class ScheduleDetailInterfaceController: WKInterfaceController {
  
  @IBOutlet var opponentNameLabel: WKInterfaceLabel!
  @IBOutlet var opponentLogo: WKInterfaceImage!
  @IBOutlet var dateLabel: WKInterfaceLabel!
  @IBOutlet var timeLabel: WKInterfaceLabel!
  @IBOutlet var locationLabel: WKInterfaceLabel!
  @IBOutlet var advantageLabel: WKInterfaceLabel!
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
        
    guard let upcomingMatchIndex = context as? Int else {
      return
    }
    
    let match = season.upcomingMatches[upcomingMatchIndex]
    
    opponentNameLabel.setText("vs \(match.opponent.name)")
    
    opponentLogo.setImageNamed(match.opponent.logoName)
    
    dateLabel.setText(match.date.mediumDate)
    
    timeLabel.setText("@ \(match.date.simpleTime)")
    
    locationLabel.setText(match.location.name)
    
    let advantage =  match.home == ourTeam ? "(home)" : "(away)"
    
    advantageLabel.setText(advantage)
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
    
    
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
}
