
import WatchKit
import Foundation


class DetailsInterfaceController: WKInterfaceController {
  @IBOutlet var table: WKInterfaceTable!
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    
    if let conditions = context as? TideConditions {
      loadTableWithLevels(conditions.waterLevels)
    }
  }
  
  func loadTableWithLevels(_ waterLevels:[WaterLevel]) {
    table.setNumberOfRows(waterLevels.count, withRowType: WaterLevelRowController.RowType);
    for i in 0..<table.numberOfRows {
      let row = table.rowController(at: i) as! WaterLevelRowController
      let waterLevel = waterLevels[i]
      row.populateWithWaterLevel(waterLevel, index: i)
    }
  }
}
