
import WatchKit

extension WKInterfaceController {
  
  /// Perform a block of code wrapped in dispatch_async on the main queue.
  func performBlock(_ block: @escaping (() -> Void)) {
    DispatchQueue.main.async(execute: block)
  }
  
}
