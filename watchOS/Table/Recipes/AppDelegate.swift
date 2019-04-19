import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  let recipeStore = RecipeStore()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    return true
  }
  
  func scheduleTimerNotificationWithUserInfo(_ userInfo: [String : Any]) {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
      guard granted else { return }
      let message = userInfo["message"] as! String
      let title = userInfo["title"] as! String
      let timer = userInfo["timer"] as! Int
      
      let content = UNMutableNotificationContent()
      content.title = title
      content.body = message
      content.categoryIdentifier = "timer"
      content.sound = UNNotificationSound.default()
      content.userInfo = userInfo
      
      var dateInfo = DateComponents()
      dateInfo.minute = timer

      let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
      let request = UNNotificationRequest(identifier: "recipes", content: content, trigger: trigger)
      
      let center = UNUserNotificationCenter.current()
      center.add(request, withCompletionHandler: { (error) in
        let result = (error == nil) ? "scheduled" : String(describing: error)
        print("UNUserNotificationCenter: \(result)")
      })
    }
  }
}
