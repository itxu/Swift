
import WatchKit
import Foundation


class InitialInterfaceController: WKInterfaceController {
  
  override init() {
    
    super.init()
    
    WKInterfaceController.reloadRootControllers(withNamesAndContexts: [("progressController", "day" as AnyObject), ("progressController", "week" as AnyObject), ("progressController", "month" as AnyObject)])
    
  }
  
}
