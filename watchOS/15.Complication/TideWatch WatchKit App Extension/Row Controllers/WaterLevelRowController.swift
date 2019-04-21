
import WatchKit

class WaterLevelRowController: NSObject {
  static let RowType = "WaterLevelRow"

  @IBOutlet var group: WKInterfaceGroup!
  @IBOutlet var dateLabel: WKInterfaceLabel!
  @IBOutlet var levelLabel: WKInterfaceLabel!
}

extension WaterLevelRowController {
  func populateWithWaterLevel(_ waterLevel:WaterLevel, index:Int) {
    levelLabel.setText(String(format: "%.1fm", waterLevel.height))
    
    let interval = waterLevel.date.timeIntervalSinceNow
    let hours = Int(round(interval / 60 / 60))
    
    if (hours == 0) {
      dateLabel.setText("Now")
      dateLabel.setTextColor(Theme.blue)
    }
    else {
      let hourString = hours > 0 ? "+\(hours)h" : "\(hours)h"
      dateLabel.setText(hourString)
    }
    
    if index % 2 == 0 {
      group.setBackgroundColor(Theme.cellBackgroundBlue)
    } else {
      group.setBackgroundColor(UIColor.clear)
    }
  }
}
