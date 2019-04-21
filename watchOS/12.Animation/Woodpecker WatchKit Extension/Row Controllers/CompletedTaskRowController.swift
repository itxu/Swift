
import UIKit
import WatchKit

class CompletedTaskRowController: NSObject {
  static let RowType = "CompletedTaskRow"

  @IBOutlet var group: WKInterfaceGroup!
  @IBOutlet var nameLabel: WKInterfaceLabel!
  @IBOutlet var progressLabel: WKInterfaceLabel!
  
}

extension CompletedTaskRowController {
  func populate(with task: Task) {
    group.setBackgroundColor(task.color.color.withAlphaComponent(0.15))
    nameLabel.setText(task.name)
    progressLabel.setText("\(task.timesCompleted)/\(task.totalTimes)")
  }
}
