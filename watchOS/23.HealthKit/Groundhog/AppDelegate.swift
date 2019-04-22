
import UIKit
import HealthKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
    // Set up appearance customizations
    UINavigationBar.appearance().barTintColor = UIColor(red: 1, green: 149/255, blue: 0, alpha: 1.0)
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
    UINavigationBar.appearance().tintColor = UIColor.black

    return true
  }
  
  // Handle a request to authorize HealthKit from the Watch Extension
  let healthStore = HKHealthStore()
  func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
    healthStore.handleAuthorizationForExtension { (success, error) in
    }
  }
  
}

