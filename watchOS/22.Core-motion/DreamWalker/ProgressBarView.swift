
import UIKit

class ProgressBarView: UIView {
  
  @IBOutlet weak var progressBar: UIView!
  @IBOutlet weak var progressBarRightConstraint: NSLayoutConstraint!
  
  var fraction: CGFloat = 1
  
  override func updateConstraints() {
    super.updateConstraints()
    // move right constraint to correct length
    let width = UIScreen.main.bounds.width
    progressBarRightConstraint.constant = (1 - fraction) * width
  }
  
  // WalkViewController calls this method
  func update(_ fraction: CGFloat) {
    self.fraction = fraction
    progressBar.backgroundColor = Walk.progressColors[Walk.progressIndex(fraction)]
    self.setNeedsUpdateConstraints()
  }
  
}
