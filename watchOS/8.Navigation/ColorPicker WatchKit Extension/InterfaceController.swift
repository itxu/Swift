import WatchKit

class InterfaceController: WKInterfaceController {
  
  @IBOutlet var colorGroup: WKInterfaceGroup!
  @IBOutlet var label: WKInterfaceLabel!
  
  override func willActivate() {
    super.willActivate()
    let color = ColorManager.defaultManager.selectedColor
    colorGroup.setBackgroundColor(color)
    label.setText("#" + color.hexString)
  }
  
  @IBAction func changeColors() {
    let colors = ColorManager.defaultManager.availableColors
    let namesAndContexts: [(name: String, context: AnyObject)] = colors.map { c in ("ColorPalette", c) }
    presentController(withNamesAndContexts: namesAndContexts)
  }
}
