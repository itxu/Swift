
import WatchKit
import CloudKit

class InterfaceController: WKInterfaceController {
  @IBOutlet var drinkAverageLabel: WKInterfaceLabel!
  @IBOutlet var infoLabel: WKInterfaceLabel!
  @IBOutlet var button: WKInterfaceButton!
  @IBOutlet var drinkCountLabel: WKInterfaceLabel!

  let ckCentral = CloudKitCentral.sharedInstance()
  let floData = FloData.sharedInstance()
  let floCal = FloCalendar()

  // MARK: - Button action
  
  @IBAction func buttonTapped() {
    floData.drinkTotal += 1
    floData.lastDate = Date()
    saveData()
    updateInterface()
  }

  // MARK: - Helper methods
  
  // Save new drink event to iCloud database directly, or via iPhone
  func saveData() {
    if ckCentral.iCloudAccountIsAvailable {
      print("Watch saving directly to iCloud")
      ckCentral.saveDate(floData.lastDate, viaWC: false)
    } else {
      // send to iPhone via Watch Connectivity
      NotificationCenter.default.post(name:
        NSNotification.Name(rawValue:
          NotificationDrinkDateOnWatch), object: nil)
    }
    
    // Update UserDefaults
    UserDefaults.standard.set(floData.drinkTotal, forKey: LocalCache.drinkTotal.rawValue)
  }
  
  func updateInterface() {
    drinkAverageLabel.setText(String(format: "%.1f", floData.drinkAverage))
    drinkCountLabel.setText(String(floData.drinkTotal))
    infoLabel.setText("Since \(floCal.formattedShort(floData.startDate))")
  }

  // MARK: - awake with context
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)

    // CloudKitCentral housekeeping
    ckCentral.checkiCloudAccountStatus()

    // 1. recordChangedBlock calls this to handle new record (pull change)
    ckCentral.updateLocalData = { record in
      self.floData.drinkTotal += 1
      print("updateLocalData with \(record["date"] as! Date)")
    }

    // 2. ckCentral calls this to cache change token
    ckCentral.cacheLocalData = { object, key in
      UserDefaults.standard.set(object, forKey: key)
    }

    // 3. checkiCloudAccountStatus() calls this to display sign-in alert
    ckCentral.alertUserToSignIn = {
      DispatchQueue.main.async {
        let okAction = WKAlertAction(title: "OK", style: .default) { }
        self.presentAlert(withTitle: "Not Signed In",
                          message: "Please sign into iCloud on your paired iPhone",
                          preferredStyle: .alert, actions: [okAction])
      }
    }

    // watchOS-specific: reload UserDefaults data
    if UserDefaults.standard.integer(forKey: LocalCache.drinkTotal.rawValue) > 0 {
      floData.drinkTotal = UserDefaults.standard.integer(forKey: LocalCache.drinkTotal.rawValue)
      floData.startDate = UserDefaults.standard.object(forKey: LocalCache.startDate.rawValue) as! Date
    } else {
      // No UserDefaults, so save startup values in UserDefaults
      UserDefaults.standard.set(floData.startDate, forKey: LocalCache.startDate.rawValue)
      UserDefaults.standard.set(floData.drinkTotal, forKey: LocalCache.drinkTotal.rawValue)
    }

    updateInterface()
  }
  
}
