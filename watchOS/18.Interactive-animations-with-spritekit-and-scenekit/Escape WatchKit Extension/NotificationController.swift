
import WatchKit
import Foundation
import UserNotifications


class NotificationController: WKUserNotificationInterfaceController {
  
  @IBOutlet var scnInterface: WKInterfaceSCNScene!
  
  override init() {
    // Initialize variables here.
    super.init()
    
    // Configure interface objects here.
    
    let confettiScene = ConfettiScene()
    scnInterface.scene = confettiScene
    scnInterface.preferredFramesPerSecond = 30
    
    // 1
    let width: CGFloat = contentFrame.width - 16
    let height: CGFloat = 80 // set in Interface Builder
    // 2
    let followPathScene =
      FollowPathScene(size: CGSize(width: width, height: height))
    // 3
    scnInterface.overlaySKScene = followPathScene
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
  
   override func didReceive(_ notification: UNNotification, withCompletion completionHandler: @escaping (WKUserNotificationInterfaceType) -> Swift.Void) {
   // This method is called when a notification needs to be presented.
   // Implement it if you use a dynamic notification interface.
   // Populate your dynamic notification interface as quickly as possible.
   //
   // After populating your dynamic notification interface call the completion block.
   completionHandler(.custom)
   }
   
}
