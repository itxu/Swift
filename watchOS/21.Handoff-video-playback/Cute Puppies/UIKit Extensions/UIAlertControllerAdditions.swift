
import UIKit

/// A helper extension for UIAlertController.
extension UIAlertController {
  
  /// A helper method to return a UIAlertController instance that has only
  /// one action button, i.e. Dismiss with a given message.
  convenience init(dismissOnlyAlertWithTitle title: String, message: String?) {
    self.init(title: title, message: message, preferredStyle: .alert)
    let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
    self.addAction(dismissAction)
  }
}

