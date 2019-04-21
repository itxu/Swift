
import WatchKit

class StationRowController: NSObject {
  static let RowType = "StationRow"

  @IBOutlet var group: WKInterfaceGroup!
  @IBOutlet var nameLabel: WKInterfaceLabel!
  @IBOutlet var stateLabel: WKInterfaceLabel!
}

extension StationRowController {
  func populateWithStation(_ station:MeasurementStation, index:Int) {
    self.nameLabel.setText(station.name)
    self.stateLabel.setText(station.state)
    
    if index % 2 == 0 {
      group.setBackgroundColor(Theme.cellBackgroundBlue)
    } else {
      group.setBackgroundColor(UIColor.clear)
    }
  }
}
