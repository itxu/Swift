
import UIKit

protocol StationsViewControllerDelegate {
  func selectedStation(_ station:MeasurementStation)
}

class StationsViewController: UITableViewController {
  let stations = MeasurementStation.allStations()
  
  var delegate: StationsViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let station = stations[(indexPath as NSIndexPath).row]
    delegate?.selectedStation(station)
  }
  
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return stations.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath)
    
    let station = stations[(indexPath as NSIndexPath).row]
    cell.textLabel?.text = station.name
    cell.detailTextLabel?.text = station.state
    
    return cell
  }

}
