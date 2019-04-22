
import UIKit

class TableViewController: UITableViewController {

	override var prefersStatusBarHidden: Bool {
		return true
	}
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return stocks.count
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 200
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! TableViewCell
    
    let stock = stocks[(indexPath as NSIndexPath).row]
    
    cell.minPriceLabel.text = stock.minPriceAsString
    cell.maxPriceLabel.text = stock.maxPriceAsString
    cell.tickerSymbolLabel.text = stock.tickerSymbol
    cell.companyName.text = stock.companyName
    cell.changeLabel.text = "\(stock.changeCharacter) \(stock.changePercentAsString)"
    cell.changeLabel.textColor = stock.changeColor
    
    cell.cardView.stock = stock
    cell.cardView.setNeedsDisplay()
    
    return cell
  }
  
}
