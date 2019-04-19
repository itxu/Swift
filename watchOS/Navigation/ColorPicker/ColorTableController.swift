import UIKit

class ColorTableController: UITableViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ColorManager.defaultManager.availableColors.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCellIdentifier")!
    if let cell = cell as? ColorCell {
      let color = ColorManager.defaultManager.availableColors[(indexPath as NSIndexPath).row]
      cell.colorView.backgroundColor = color
      cell.colorLabel.text = "#" + color.hexString
    }
    return cell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let detail = segue.destination as? ColorDetailController,
      let row = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row,
      segue.identifier == "ColorDetailSegue" {
      detail.color = ColorManager.defaultManager.availableColors[row]
    }
  }
  
}
