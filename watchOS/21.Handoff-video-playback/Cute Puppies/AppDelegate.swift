
import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  /// The WatchConnectivity session to send poster images if needed.
  private var session: WCSession?
  
  /// A reference map to create poster images for each video clip and
  /// send them to the watch app.
  private let references = VideoClipProvider().clipReferences
  
  /// A convenient getter that returns a pointer to the root interface
  /// controller of the app.
  private var appRootViewController: BrowserViewController {
    return (window!.rootViewController as! UINavigationController).viewControllers.first! as! BrowserViewController
  }
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    if WCSession.isSupported() {
      session = WCSession.default
      session!.delegate = self
      session!.activate()
    }
    return true
  }
  
  // MARK: Handoff
  
  func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
    return true
  }
  
  func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
    print("Received: \(userActivity.userInfo ?? [:])")
    guard
      let userInfo = userActivity.userInfo,
      let version = userInfo[Handoff.version.key] as? Int,
      version == Handoff.version.number
      else { return false }
    let err =  NSError(domain: "foo", code: NSKeyValueValidationError, userInfo: [:])
    self.application(application, didFailToContinueUserActivityWithType: userActivity.activityType, error: err)
    appRootViewController.restoreUserActivityState(userActivity)
    return true
  }
  
  func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
    print("Handoff Error: \(error.localizedDescription)")
    let error = error as NSError
    guard error.code != NSUserCancelledError else {
      return
    }
    
    let message = "The connection to your other device may have been interrupted. Please try again."
    let title = "Handoff Error"
    
    let alertController = UIAlertController(dismissOnlyAlertWithTitle: title, message: message) as UIViewController
    appRootViewController.present(alertController, animated: true, completion: nil)
  }
}

// MARK: WatchConnectivity

extension AppDelegate: WCSessionDelegate {
  
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    print("📱 WCSession activationDidCompleteWith: \(activationState.rawValue)")
  }
  
  func sessionDidBecomeInactive(_ session: WCSession) {
    print("📱 WCSession sessionDidBecomeInactive.")
  }
  
  func sessionDidDeactivate(_ session: WCSession) {
    print("📱 WCSession sessionDidDeactivate.")
  }
  
  func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    
    print("📱 WCSession received message: \(message)")
    
    guard let value = message[VideoClipProvider.WCPosterImageRequestKey] as? String else {
      print("📱 WCSession message not handled.")
      return
    }
    
    guard let URL = references[value] else {
      print("📱 WCSession message not handled.")
      return
    }
    
    guard let directory = session.watchDirectoryURL else {
      print("📱 WCSession failed to get watch directory URL.")
      return
    }
    
    let newSize = CGSize(width: 312.0, height: 234.0)
    let file = directory.appendingPathComponent(value)
    
    VideoUtilities.snapshot(fromMovieAtURL: URL, resizeTo: newSize) { (image) in
      print("📱 WCSession sending image \(image) at \(file).")
      let data = UIImagePNGRepresentation(image)!
      try! data.write(to: file)
      session.transferFile(file, metadata: [VideoClipProvider.WCPosterImageRequestKey: value])
    }
  }
  
  func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
    print("📱 WCSession didFinish fileTransfer \(fileTransfer) - \(String(describing: error?.localizedDescription))")
  }
}

