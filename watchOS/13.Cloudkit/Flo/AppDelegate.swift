
import UIKit
import CloudKit
import WatchConnectivity
// WatchConnectivity notifications
let NotificationDrinkDateOnWatch = "DrinkDateOnWatch"
let NotificationiPhoneDataUpdated = "iPhoneDataUpdated"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  let ckCentral = CloudKitCentral.sharedInstance()
  lazy var notificationCenter: NotificationCenter = {
    return NotificationCenter.default
  }()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    application.registerForRemoteNotifications()

    setupWatchConnectivity()
    setupNotificationCenter()
    
    return true
  }
  
  // MARK: - Notification Center for WC
  private func setupNotificationCenter() {
    notificationCenter.addObserver(forName: NSNotification.Name(rawValue: NotificationiPhoneDataUpdated), object: nil, queue: nil) { (notification:Notification) -> Void in
      self.sendFloDataToWatch(notification)
    }
  }

  // MARK: - CloudKit notifications
  // NOTE: remote notifications are not supported in the simulator
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("didRegisterForRemoteNotificationsWithDeviceToken \(deviceToken)")
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("didFailToRegisterForRemoteNotificationsWithError ERROR: \(error.localizedDescription)")
  }

  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    let notification = CKNotification(fromRemoteNotificationDictionary: userInfo as! [String : NSObject])
    if notification.subscriptionID == "new-drink-event" {
      ckCentral.qos = .utility
      ckCentral.fetchDatabaseChanges {
        completionHandler(.newData)
      }
    }
  }

}

// MARK: - Watch Connectivity
extension AppDelegate: WCSessionDelegate {
  
  func setupWatchConnectivity() {
    if WCSession.isSupported() {
      let session = WCSession.default
      session.delegate = self
      session.activate()
    }
  }
  
  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
    if let watchDate = applicationContext["watchDate"] as? Date {
      print("didReceiveApplicationContext from Watch: \(watchDate)")
      ckCentral.saveDate(watchDate, viaWC: true)
    }
  }
  
  func sendFloDataToWatch(_ notification: Notification) {
    guard WCSession.isSupported() && WCSession.default.isWatchAppInstalled else { return }
    
    let floData = FloData.sharedInstance()
    let currentDrinkTotal = floData.drinkTotal
    print("sendFloDataToWatch drinkTotal \(floData.drinkTotal)")
    do {
      let dictionary = [LocalCache.startDate.rawValue: floData.startDate, LocalCache.drinkTotal.rawValue: currentDrinkTotal] as [String : Any]
      try WCSession.default.updateApplicationContext(dictionary as [String : AnyObject])
    } catch {
      print("sendFloDataToWatch ERROR: \(error.localizedDescription)")
    }
  }
  
  func sessionDidBecomeInactive(_ session: WCSession) {
    print("WC Session did become inactive")
  }
  
  func sessionDidDeactivate(_ session: WCSession) {
    print("WC Session did deactivate")
    WCSession.default.activate()
  }
  
  func session(_ session: WCSession, activationDidCompleteWith
    activationState: WCSessionActivationState, error: Error?) {
    if let error = error {
      print("WC Session activation failed with error: " +
        "\(error.localizedDescription)")
      return
    }
    print("WC Session activated with state: " +
      "\(activationState.rawValue)")
  }
  
}

