
import UIKit
import WatchConnectivity

let NotificationPurchasedMovieOnPhone = "PurchasedMovieOnPhone"
let NotificationPurchasedMovieOnWatch = "PurchasedMovieOnWatch"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  lazy var notificationCenter: NotificationCenter = {
    return NotificationCenter.default
    }()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    setupTheme(application: application)
    setupWatchConnectivity()
    setupNotificationCenter()
    return true
  }
  
  // MARK: - Theme
  
  private func setupTheme(application: UIApplication) {
    // UINavigationBar
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor(red:1, green:1, blue:1, alpha:1)]
    UINavigationBar.appearance().barTintColor = UIColor(red: 157.0/255.0, green: 42.0/255.0, blue: 42.0/255.0, alpha: 1.0)
    
    // UIScrollView and UITableView
    UITableView.appearance().backgroundColor = UIColor(red: 43/255.0, green: 43/255.0, blue: 43/255.0, alpha: 1)
    
    // Application
    application.statusBarStyle = UIStatusBarStyle.lightContent
  }
  
  // MARK: - Notification Center
  
  private func setupNotificationCenter() {
    notificationCenter.addObserver(forName: NSNotification.Name(rawValue: NotificationPurchasedMovieOnPhone), object: nil, queue: nil) { (notification:Notification) -> Void in
      self.sendPurchasedMoviesToWatch(notification)
    }
  }
}

// MARK: - Watch Connectivity
extension AppDelegate: WCSessionDelegate {
  // 1
  func sessionDidBecomeInactive(_ session: WCSession) {
    print("WC Session did become inactive")
  }
  
  // 2
  func sessionDidDeactivate(_ session: WCSession) {
    print("WC Session did deactivate")
    WCSession.default.activate()
  }
  
  // 3
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    if let error = error {
      print("WC Session activation failed with error: \(error.localizedDescription)")
      return
    }
    print("WC Session activated with state: \(activationState.rawValue)")
  }
  
  func setupWatchConnectivity() {
    // 1
    if WCSession.isSupported() {
      // 2
      let session = WCSession.default
      // 3
      session.delegate = self
      // 4
      session.activate()
    }
  }
  
  func sendPurchasedMoviesToWatch(_ notification: Notification) {
    // 1
    if WCSession.isSupported() {
      // 2
      if let movies =
        TicketOffice.sharedInstance.purchasedMovieTicketIDs() {
        // 3
        let session = WCSession.default
        if session.isWatchAppInstalled {
          // 4
          do {
            let dictionary = ["movies": movies]
            try session.updateApplicationContext(dictionary)
          } catch {
            print("ERROR: \(error)")
          }
        }
      }
    }
  }
  
  // 1
  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
    // 2
    if let movies = applicationContext["movies"] as? [String] {
      // 3
      TicketOffice.sharedInstance.purchaseTicketsForMovies(movies)
      //4
      DispatchQueue.main.async {
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(
          name: NSNotification.Name(rawValue: NotificationPurchasedMovieOnWatch), object: nil)
      }
    }
  }

}
