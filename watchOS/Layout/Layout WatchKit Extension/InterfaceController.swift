import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
  @IBOutlet var expandedCommentLabel: WKInterfaceLabel!
  @IBOutlet var collapsedCommentLabel: WKInterfaceLabel!
  @IBOutlet var moreLabel: WKInterfaceLabel!
  var expanded = false

  override func awake(withContext context: Any?) {
    WKExtension.shared().isAutorotating = true
  }
  
  @IBAction func onMoreButton() {
    // 1
    expanded = !expanded
    // 2
    collapsedCommentLabel.setHidden(expanded)
    expandedCommentLabel.setHidden(!expanded)
    // 3
    moreLabel.setText("Tap to " + (expanded ? "view less" : "view more") + "...")
    // 4
    if expanded {
      scroll(to: expandedCommentLabel, at: .top, animated: true)
    }
  }
}
