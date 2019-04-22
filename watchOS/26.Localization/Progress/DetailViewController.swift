
import UIKit

class DetailViewController: UIViewController {
  
  let ringAnimationFrames = 180
  
  var day: Day!
  
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var unitsLabel: UILabel!
  @IBOutlet weak var averageSellingPriceLabel: UILabel!
  @IBOutlet weak var statusImage: UIImageView!
  @IBOutlet weak var goalLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    
    self.title = dateFormatter.string(from: day.date as Date)
    
    let currencyFormatter = NumberFormatter()
    currencyFormatter.numberStyle = .currency
    currencyFormatter.maximumFractionDigits = 0
    
    statusLabel.text = currencyFormatter.string(from: NSNumber(value: day.status))
    
    goalLabel.text = "OF " + currencyFormatter.string(from: NSNumber(value: day.goal))!
    
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    
    unitsLabel.text = numberFormatter.string(from: NSNumber(value: day.units))! + " units"
    
    averageSellingPriceLabel.text = currencyFormatter.string(from: NSNumber(value: day.averageSellingPrice))
    
    statusImage.image = UIImage(named: "iosring" + String(Int(day.status / day.goal * Double(ringAnimationFrames))))
  }
  
  
}
