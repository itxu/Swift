import WatchKit
import Foundation


class ColorController: WKInterfaceController {
  @IBOutlet var backgroundGroup: WKInterfaceGroup!
  @IBOutlet var label: WKInterfaceLabel!
  
  var activeColor = UIColor.white
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    if let color = context as? UIColor {
      update(color: color)
    }
  }
  
  override func didAppear() {
    super.didAppear()
    updateSelectedColor()
  }
  
  func update(color: UIColor) {
    activeColor = color
    backgroundGroup.setBackgroundColor(color)
    label.setText("#" + color.hexString)
  }
  
  func updateSelectedColor() {
    ColorManager.defaultManager.selectedColor = activeColor
  }
  
  @IBAction func onDarken() {
    update(color: activeColor.darkerColor())
    updateSelectedColor()
  }
  
  @IBAction func onLighten() {
    update(color: activeColor.lighterColor())
    updateSelectedColor()
  }
}
