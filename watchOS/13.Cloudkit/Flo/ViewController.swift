

import UIKit
import CloudKit

class ViewController: UIViewController {
  // Counter outlets
  @IBOutlet weak var counterView: CounterView!
  @IBOutlet weak var counterLabel: UILabel!
  @IBOutlet weak var drinkTotalLabel: UILabel!
  @IBOutlet weak var startDateLabel: UILabel!
  @IBOutlet weak var pushButton: PushButtonView!
  @IBOutlet weak var refreshButton: UIBarButtonItem!

  // MARK: - Shared classes
  let ckCentral = CloudKitCentral.sharedInstance()
  let floData = FloData.sharedInstance()
  let floCal = FloCalendar()
  
  // MARK: - iOS-specific local data storage
  var drinkEvents = [Date]()
  lazy var saveFileUrl: URL = {
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    return documentDirectory.appendingPathComponent("drinkEvents.bin")
  }()

  // MARK: - View life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // CloudKitCentral housekeeping
    ckCentral.checkiCloudAccountStatus()

    // queryOperation.recordChangedBlock calls this to handle new record
    ckCentral.updateLocalData = { record in
      let date = record["date"] as! Date
      
      // Prevent duplicate dates in local array when app relaunches
      if self.drinkEvents.contains(date) { return }
      
      if date < self.floData.startDate {
        self.floData.startDate = date
        UserDefaults.standard.set(self.floData.startDate, forKey: "startDate")
      }
      
      print("updateLocalData with \(date)")
      self.drinkEvents.append(date)
      self.saveLocalArray()
      // Set this so Watch app doesn't need to pull database changes
      self.floData.drinkTotal = self.drinkEvents.count

      DispatchQueue.main.async {
        if UIApplication.shared.applicationState == .active {
          self.updateView() }
        else {
          NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationiPhoneDataUpdated), object: nil)
        }
      }
    }
    
    // createSubscriptionOperation.modifySubscriptionsCompletionBlock calls this
    // to cache subscriptionsSaved and change token
    ckCentral.cacheLocalData = { object, key in
      UserDefaults.standard.set(object, forKey: key)
    }
    
    // checkiCloudAccountStatus() calls this to display sign-in alert, disable buttons
    ckCentral.alertUserToSignIn = {
      let alert = UIAlertController(title: "Not Signed In", message: "Please sign into iCloud before using this app", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
      DispatchQueue.main.async {
        self.present(alert, animated: true, completion: nil)
        self.turnButtons(on: false)
      }
    }
    
    // iOS-specific: reload archived drinkEvents array
    if FileManager.default.fileExists(atPath: saveFileUrl.path) {
      // display local data before checking for CK changes
      loadLocalArray()
      floData.startDate = UserDefaults.standard.object(forKey: LocalCache.startDate.rawValue) as! Date
      ckCentral.subscribedToPrivateChanges = UserDefaults.standard.object(forKey: LocalCache.subscriptionsSaved.rawValue) as! Bool
      let tokenData = UserDefaults.standard.object(forKey: LocalCache.changeToken.rawValue) as! Data
      ckCentral.token = (NSKeyedUnarchiver.unarchiveObject(with: tokenData) as! CKServerChangeToken)
    } else {
      UserDefaults.standard.set(floData.startDate, forKey: "startDate")
      UserDefaults.standard.set(false, forKey: "subscriptionsSaved")
    }
    updateView()
    
    pullChanges()
  }

  // MARK: - Helper method

  func updateView() {
    // FloData computes drinkAverage from drinkTotal and startDate
    floData.drinkTotal = drinkEvents.count
    counterLabel.text = String(format: "%.1f", floData.drinkAverage)
    drinkTotalLabel.text = String(drinkEvents.count)
    startDateLabel.text = "SINCE\n" + floCal.formattedShort(floData.startDate)
    
    counterView.counter = floData.drinkAverage
    counterView.setNeedsDisplay()
    
    NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationiPhoneDataUpdated), object: nil)
  }
  
  // MARK: - Button actions
  @IBAction func tappedPushButton(_ button: PushButtonView) {
    let now = Date()
    drinkEvents.append(now)
    // Set this so Watch app doesn't need to pull database changes
    UserDefaults.standard.set(self.drinkEvents.count, forKey: "drinkTotal")
    
    updateView()
    
    saveLocalArray()
    ckCentral.saveDate(now, viaWC: false)
  }
  
  @IBAction func pullChanges() {
    // Raise fetch-op priority from default .utility
    ckCentral.qos = .userInitiated
    ckCentral.fetchDatabaseChanges() {  }
  }
  
  func turnButtons(on enableSwitch: Bool) {
    pushButton.isEnabled = enableSwitch
    refreshButton.isEnabled = enableSwitch
  }
  
  // MARK: - Archive/unarchive drinkEvents array
  func saveLocalArray() {
    guard drinkEvents.count > 0 else { return }
    if NSKeyedArchiver.archiveRootObject(drinkEvents, toFile: saveFileUrl.path) {
      print("Saved local array")
    }
  }
  
  func loadLocalArray() {
    //    guard let saveFileUrl = saveFileUrl else { return }
    do {
      let data = try Data(contentsOf: saveFileUrl, options: [.mappedIfSafe])
      drinkEvents = NSKeyedUnarchiver.unarchiveObject(with: data) as! [Date]
    } catch {
      print("loadLocalArray ERROR: \(error.localizedDescription)")
    }
  }
  
}

