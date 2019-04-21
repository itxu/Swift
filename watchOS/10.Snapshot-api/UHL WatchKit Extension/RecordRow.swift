

import WatchKit

class RecordRow: NSObject {
  // Assumes away team on top; home team on bottom
  @IBOutlet var awayGroup: WKInterfaceGroup!
  @IBOutlet var homeGroup: WKInterfaceGroup!
  @IBOutlet var awayLogo: WKInterfaceImage!
  @IBOutlet var homeLogo: WKInterfaceImage!
  @IBOutlet var awayNameLabel: WKInterfaceLabel!
  @IBOutlet var homeNameLabel: WKInterfaceLabel!
  @IBOutlet var awayScoreLabel: WKInterfaceLabel!
  @IBOutlet var homeScoreLabel: WKInterfaceLabel!
  @IBOutlet var dateLabel: WKInterfaceLabel!
}
