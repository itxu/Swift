
import UIKit

class TaskCell: UITableViewCell {
  static let ReuseId = "TaskCell"
  
  @IBOutlet weak var progressView: ProgressView!
  @IBOutlet weak var nameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
  }
}

// MARK: Populate Cell
extension TaskCell {
  func updateWithTask(_ task:Task) {
    nameLabel.text = task.name
    progressView.update(task.color.color, current: task.timesCompleted, total: task.totalTimes)
  }
}
