
import UIKit

class ProgressView: UIView {
  @IBOutlet weak var progressLabel: UILabel!
  @IBOutlet weak var progressBarView: UIView!
  @IBOutlet weak var progressBarLeftConstraint: NSLayoutConstraint!
  @IBOutlet weak var completeImage: UIImageView!
    
  var total = 1
  var current = 1
  
  override func updateConstraints() {
    super.updateConstraints()
    if (total > 0) {
      let progress = CGFloat(current)/CGFloat(total)
      let width = bounds.width

      let randomOffset: CGFloat
      if (current != 0 && current != total) {
        // Spice it up by adding a bit of randomness
        let wiggleRoom = width / CGFloat(total)
        let randomFloat = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        randomOffset = (wiggleRoom * randomFloat) - wiggleRoom / 2
      }
      else {
        randomOffset = 0
      }
      
      progressBarLeftConstraint.constant = progress * width + randomOffset
    }
  }
  
  func update(_ color: UIColor, current: Int, total: Int) {
    self.current = current
    self.total = total
    
    progressBarView.backgroundColor = color
    progressLabel.text = "\(current)/\(total)"
    
    completeImage.isHidden = current != total
    progressLabel.isHidden = !completeImage.isHidden
    
    setNeedsUpdateConstraints()
  }
}
