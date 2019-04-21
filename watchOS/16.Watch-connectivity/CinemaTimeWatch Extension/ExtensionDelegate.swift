

import WatchKit
import WatchConnectivity

let NotificationPurchasedMovieOnWatch = "PurchasedMovieOnWatch"

class ExtensionDelegate: NSObject, WKExtensionDelegate {
  
  lazy var documentsDirectory: String = {
      return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
    }()
  
  lazy var notificationCenter: NotificationCenter = {
    return NotificationCenter.default
    }()
  
  func applicationDidFinishLaunching() {
    setupWatchConnectivity()
    setupNotificationCenter()
  }
  
  // MARK: - Notification Center
  
  private func setupNotificationCenter() {
    notificationCenter.addObserver(forName: NSNotification.Name(rawValue: NotificationPurchasedMovieOnWatch), object: nil, queue: nil) { (notification:Notification) -> Void in
      self.sendPurchasedMoviesToPhone(notification)
    }
  }
}

// MARK: - Watch Connectivity
extension ExtensionDelegate: WCSessionDelegate {
  
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    if let error = error {
      print("WC Session activation failed with error: \(error.localizedDescription)")
      return
    }
    print("WC Session activated with state: \(activationState.rawValue)")
  }
  
  func setupWatchConnectivity() {
    if WCSession.isSupported() {
      let session  = WCSession.default
      session.delegate = self
      session.activate()
    }
  }
  
  // 1
  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
    // 2
    if let movies = applicationContext["movies"] as? [String] {
      // 3
      TicketOffice.sharedInstance.purchaseTicketsForMovies(movies)
      // 4
      DispatchQueue.main.async {
        WKInterfaceController.reloadRootPageControllers(withNames: ["PurchasedMovieTickets"],
                                                        contexts: nil,
                                                        orientation: WKPageOrientation.vertical,
                                                        pageIndex: 0)
      }
    }
  }
  
  func sendPurchasedMoviesToPhone(_ notification:Notification) {
    // 1
    if WCSession.isSupported() {
      // 2
      if let movies =
        TicketOffice.sharedInstance.purchasedMovieTicketIDs() {
        // 3
        do {
          let dictionary = ["movies": movies]
          try WCSession.default.updateApplicationContext(dictionary)
        } catch {
          print("ERROR: \(error)")
        }
      }
    }
  }
}
