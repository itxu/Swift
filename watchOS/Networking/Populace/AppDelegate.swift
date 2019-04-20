import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {

    // Set up appearance customizations
    UINavigationBar.appearance().barTintColor = UIColor(red: 0x5a/0xff, green: 0xc8/0xff, blue: 0xfa/0xff, alpha: 1.0)
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
    UINavigationBar.appearance().tintColor = UIColor.black
    
    return true
  }

}

