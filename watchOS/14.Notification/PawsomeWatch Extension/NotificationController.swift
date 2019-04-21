import WatchKit
import Foundation
import UserNotifications

// 1
class NotificationController: WKUserNotificationInterfaceController {
  
  // 2
  @IBOutlet var label: WKInterfaceLabel!
  @IBOutlet var image: WKInterfaceImage!
  
  // 1
  override func didReceive(_ notification: UNNotification, withCompletion completionHandler: @escaping (WKUserNotificationInterfaceType) -> Void) {
    
    // 2
    let notificationBody = notification.request.content.body
    label.setText(notificationBody)
    
    // 3
    if let imageAttachment = notification.request.content.attachments.first {
      let imageURL = imageAttachment.url
      let imageData = try! Data(contentsOf: imageURL)
      let newImage = UIImage(data: imageData)
      image.setImage(newImage)
    } else {
      let catImageName = String(format: "cat%02d",
                                arguments: [Int.randomInt(1, max: 20)])
      image.setImageNamed(catImageName)
    }
    
    // 4
    completionHandler(.custom)
  }
}
