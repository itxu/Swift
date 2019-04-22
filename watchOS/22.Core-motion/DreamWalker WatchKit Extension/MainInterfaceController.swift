
import WatchKit
import Foundation
import WatchConnectivity

class MainInterfaceController: WKInterfaceController, WCSessionDelegate {
  @IBOutlet var walkTable: WKInterfaceTable!
  
  lazy var walks: [Walk] = {
    let path = Bundle.main.path(forResource:"Walks", ofType: "plist")
    let arrayOfDicts = NSArray(contentsOfFile: path!)!
    var array = [Walk]()
    for i in 0..<arrayOfDicts.count {
      let walk = Walk.convertDictToWalk(arrayOfDicts[i] as! [String : AnyObject])
      array.append(walk)
    }
    return array as Array
    }()
  
  let data = PedometerData()
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
  }
  
  override func willActivate() {
    loadTable()
  }
  
  func loadTable() {
    walkTable.setNumberOfRows(walks.count, withRowType: "walkRow")
    for i in 0..<walks.count {
      let controller = walkTable.rowController(at: i) as! WalkRowController
      controller.titleLabel.setText(walks[i].walkTitle)
      
      // completions; hide star if < 1
      let completions = data.totalDistance / CGFloat(walks[i].goal)
      controller.starLabel.setHidden(completions < 1.0)
      
      // progress bar
      let fraction = completions.fraction()
      controller.progressGroup.setWidth(fraction * contentFrame.size.width)
      controller.progressGroup.setBackgroundColor(Walk.progressColors[Walk.progressIndex(fraction)])
    }
  }
  
  override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
    return [walks[rowIndex], data]
  }
  
  // WCSessionDelegate method
  
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    
  }

}
