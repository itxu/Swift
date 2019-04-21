
import WatchKit

class ChartRowController: NSObject {
  
  @IBOutlet fileprivate weak var imageView: WKInterfaceImage!
  
  var image: UIImage? {
    willSet(newImage) {
      imageView!.setImage(newImage)
    }
  }
}
