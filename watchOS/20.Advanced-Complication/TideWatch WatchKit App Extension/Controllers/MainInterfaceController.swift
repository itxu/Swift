
import WatchKit

class MainInterfaceController: WKInterfaceController {
  @IBOutlet var nameLabel: WKInterfaceLabel!
  @IBOutlet var stateLabel: WKInterfaceLabel!
  @IBOutlet var waterLevelLabel: WKInterfaceLabel!
  @IBOutlet var averageWaterLevelLabel: WKInterfaceLabel!
  @IBOutlet var tideLabel: WKInterfaceLabel!
  
  var tideConditions: TideConditions = TideConditions.loadConditions()
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
  }
  
  override func willActivate() {
    super.willActivate()
    populateStationData()
    populateTideData()
    refresh()
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(forName: NSNotification.Name(rawValue: PhoneUpdatedDataNotification), object: nil, queue: nil) { notification in
      if let conditions = notification.object as? TideConditions {
        self.tideConditions = conditions;
        DispatchQueue.main.async {
          self.populateStationData()
          self.populateTideData()
        }
      }
    }
  }
  
  override func didDeactivate() {
    super.didDeactivate()
    let notificationCenter = NotificationCenter.default
    notificationCenter.removeObserver(self)
  }
  
  override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
    return tideConditions
  }
}

// MARK: Load Data
extension MainInterfaceController {
  func refresh() {
    let yesterday = Date(timeIntervalSinceNow: -24 * 60 * 60)
    let tomorrow = Date(timeIntervalSinceNow: 24 * 60 * 60)
    tideConditions.loadWaterLevels(from: yesterday, to: tomorrow) { success in
      DispatchQueue.main.async {
        if success {
          self.populateTideData()
          TideConditions.saveConditions(self.tideConditions)
          let notificationCenter = NotificationCenter.default
          notificationCenter.post(name: Notification.Name(rawValue: WatchUpdatedDataNotification), object: self.tideConditions)
        }
        else {
          print("Failed to load station: \(self.tideConditions.station.name)")
        }
      }
    }
  }
  
  func populateStationData() {
    nameLabel.setText(tideConditions.station.name)
    stateLabel.setText(tideConditions.station.state)
  }
  
  func populateTideData() {
    guard tideConditions.waterLevels.count > 0 else {
      waterLevelLabel.setText("--")
      tideLabel.setText("--")
      averageWaterLevelLabel.setText("--")
      return
    }
    
    if let currentWaterLevel = tideConditions.currentWaterLevel {
      waterLevelLabel.setText(String(format: "%.1fm", currentWaterLevel.height))
      tideLabel.setText(currentWaterLevel.situation.rawValue)
    }
    averageWaterLevelLabel.setText(String(format: "%.1fm", tideConditions.averageWaterLevel))
  }
}
