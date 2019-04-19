import WatchKit
import Foundation


class DetailController: WKInterfaceController {
  @IBOutlet var hexLabel: WKInterfaceLabel!
  @IBOutlet var rgbLabel: WKInterfaceLabel!
  @IBOutlet var hslLabel: WKInterfaceLabel!
  
  override func willActivate() {
    super.willActivate()
    let color = ColorManager.defaultManager.selectedColor
    hexLabel.setText("#" + color.hexString)
    rgbLabel.setText(color.rgbString)
    hslLabel.setText(color.hslString)
  }
}
