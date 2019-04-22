
import UIKit

class MeetupGroupCell: UITableViewCell {
  
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var locationLabel: UILabel!
  @IBOutlet var membersLabel: UILabel!
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // A block of animation code to run when cell is selected.
    let animationBlockSelected: (() -> Void) = {
      self.contentView.alpha = 0.5
      self.backgroundColor = UIColor.themeTintColor().withAlphaComponent(0.3)
    }
    
    // A block of animation code to run when cell is unselected.
    let animationBlockUnselected: (() -> Void) = {
      self.contentView.alpha = 1.0
      self.backgroundColor = UIColor.white
    }
    
    let animationBlock = (selected) ? animationBlockSelected : animationBlockUnselected
    UIView.animate(withDuration: 0.25, animations: animationBlock)
  }
  
}
