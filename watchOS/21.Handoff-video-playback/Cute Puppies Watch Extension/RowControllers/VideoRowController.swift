
import WatchKit

class VideoRowController: NSObject {
  
  // MARK: Private
  
  static let IBIdentifier = "VideoRowController"
  
  @IBOutlet var image: WKInterfaceImage!
  @IBOutlet var textLabel: WKInterfaceLabel!
  
  // MARK: Public
  
  override init() {
    super.init()
  }
}
