
import WatchKit

class PopulationFactRowController: NSObject {
  
  @IBOutlet fileprivate weak var detailLabel: WKInterfaceLabel!
  
  var factObject: PopulationFactObject? {
    willSet(fact) {
      detailLabel.setText(fact!.populationFactString)
    }
  }
}
