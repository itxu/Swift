import WatchKit
import Foundation
import UserNotifications

extension Int {
  static func randomInt(_ min: Int, max:Int) -> Int {
    return min + Int(arc4random_uniform(UInt32(max - min + 1)))
  }
}

class InterfaceController: WKInterfaceController {
  
  @IBOutlet var table: WKInterfaceTable!
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    setupTable()
    registerUserNotificationSettings()
    scheduleLocalNotification()
  }
  
  func setupTable() {
    let numberOfCatImages = 20
    table.setNumberOfRows(numberOfCatImages, withRowType: "CatRowType")
    for index in 1...numberOfCatImages {
      if let controller = table.rowController(at: index-1) as? CatImageRowController {
        let catImageName = String(format: "cat%02d", arguments: [index])
        controller.catImage.setImageNamed(catImageName)
      }
    }
  }
}

// Notification Methods

extension InterfaceController {
  
  func registerUserNotificationSettings() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
      if granted {
        let viewCatsAction = UNNotificationAction(identifier: "viewCatsAction", title: "More Cats!", options: .foreground)
        let pawsomeCategory = UNNotificationCategory(identifier: "Pawsome", actions: [viewCatsAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([pawsomeCategory])
        UNUserNotificationCenter.current().delegate = self
        print("⌚️⌚️⌚️Successfully registered notification support")
      } else {
        print("⌚️⌚️⌚️ERROR: \(String(describing: error?.localizedDescription))")
      }
    }
  }
  
  func scheduleLocalNotification() {
    
    UNUserNotificationCenter.current().getNotificationSettings { (settings) in
      if settings.alertSetting == .enabled {
        
        let catImageName = String(format: "cat images/local_cat%02d",
                                  arguments: [Int.randomInt(1, max: 20)])
        let catImageURL = Bundle.main.url(forResource: catImageName, withExtension: "jpg")
        let notificationAttachment = try! UNNotificationAttachment(identifier: catImageName, url: catImageURL!, options: .none)
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Pawsome"
        notificationContent.subtitle = "Guess what time it is"
        notificationContent.body = "Pawsome time!"
        notificationContent.categoryIdentifier = "Pawsome"
        notificationContent.attachments = [notificationAttachment]
        
        var date = DateComponents()
        date.minute = 30
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

        
        let notificationRequest = UNNotificationRequest(identifier: "Pawsome", content: notificationContent, trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
          if let error = error {
            print("⌚️⌚️⌚️ERROR:\(error.localizedDescription)")
          } else {
            print("⌚️⌚️⌚️Local notification was scheduled")
          }
        }
      } else {
        print("⌚️⌚️⌚️Notification alerts are disabled")
      }
    }
  }
}

// Notification Center Delegate
extension InterfaceController: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert, .sound])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    completionHandler()
  }
}
