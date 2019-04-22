
import WatchKit
import Foundation


class StationsInterfaceController: WKInterfaceController {
  @IBOutlet var table: WKInterfaceTable!
  
  var tideConditions: TideConditions?
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    
    tideConditions = context as? TideConditions
    
    loadStations()
  }
  
  func loadStations() {
    let stations = MeasurementStation.allStations()
    table.setNumberOfRows(stations.count, withRowType: StationRowController.RowType);
    for i in 0..<table.numberOfRows {
      let row = table.rowController(at: i) as! StationRowController
      let station = stations[i]
      row.populateWithStation(station, index:i)
    }
  }
  
  override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
    let stations = MeasurementStation.allStations()
    let station = stations[rowIndex]
    tideConditions?.station = station
    pop()
  }
}
