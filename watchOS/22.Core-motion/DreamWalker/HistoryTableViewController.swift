
import UIKit

class HistoryTableViewController: UITableViewController {
  
  var history: [DayData]?
  var distanceUnit = "km"
  
  let km2mi = 0.621371192
  let dateFormatter = DateFormatter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dateFormatter.dateStyle = .long
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if history != nil {
      return history!.count
    }
    return 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
    
    if let history = history {
      let dayData = history[(indexPath as NSIndexPath).row]
      cell.textLabel!.text = dateFormatter.string(from: dayData.date as Date)
      if distanceUnit == "km" {
        let formattedString = String(format:"%.2f", dayData.distance)
        cell.detailTextLabel!.text = "\(dayData.steps) steps \(formattedString)km"
      } else {
        let formattedString = String(format:"%.2f", dayData.distance * km2mi)
        cell.detailTextLabel!.text = "\(dayData.steps) steps \(formattedString)mi"
      }
    }
    
    return cell
  }
  
}
