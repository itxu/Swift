
import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
  
  func handleUserActivity(
    _ userInfo: [AnyHashable : Any]?) {
    if let date = userInfo?[CLKLaunchedTimelineEntryDateKey]
      as? Date {
      print("launched from complication with date:\(date)")
    }
  }

}
