import UIKit
import UserNotifications

extension Int {
  static func randomInt(_ min: Int, max:Int) -> Int {
    return min + Int(arc4random_uniform(UInt32(max - min + 1)))
  }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    registerUserNotificationSettings()
    scheduleLocalNotification()
    return true
  }
}

// Notification Center Delegate
extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert, .sound])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    completionHandler()
  }
}

// Notification Center
extension AppDelegate {
  
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

