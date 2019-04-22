
import UIKit

@IBDesignable
class CircleButton: UIButton {
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    layer.cornerRadius = min(bounds.size.width, bounds.size.height) * 0.5
    layer.borderWidth = 2.0
    layer.borderColor = self.tintColor.cgColor
    layer.masksToBounds = true
  }
  
}
