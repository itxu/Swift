
import WatchKit

class ExerciseTypeRowController: NSObject {

  @IBOutlet fileprivate weak var titleLabel: WKInterfaceLabel!
  @IBOutlet fileprivate weak var detailLabel: WKInterfaceLabel!

  var exerciseType: ExerciseType? {
    willSet(type) {
      titleLabel.setText(type!.title)
      detailLabel.setText(type!.locationName)
    }
  }
}
