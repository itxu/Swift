
import UIKit
import MapKit

class WalkViewController: UIViewController {
  
  @IBOutlet weak var image: UIImageView!
  @IBOutlet weak var goalLabel: UILabel!
  @IBOutlet weak var progressBarView: ProgressBarView!
  @IBOutlet weak var walkLabel: UILabel!
  @IBOutlet weak var infoTextView: UITextView!
  
  var walk: Walk?
  var distanceUnit = "km"
  var completions: CGFloat = 0.0
  var completionString = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let walk = walk {
      image.image = UIImage(named: walk.imageName)
      
      if distanceUnit == "km" {
        let formattedString = String(format:"%.2f", walk.goal)
        goalLabel.text = "Goal: \(formattedString)km completed \(completionString) times"
      } else {
        let formattedString = String(format:"%.2f", walk.goal.imperial())
        goalLabel.text = "Goal: \(formattedString)mi completed \(completionString) times"
      }
      
      // progress bar shows color-coded progress towards the next completion
      progressBarView.update(completions.fraction())
      
      walkLabel.text = walk.walkTitle
      infoTextView.text = walk.info
    }
  }
  
  @IBAction func openMaps(_ sender: AnyObject) {
    let launchOptions = [MKLaunchOptionsMapTypeKey: MKMapType.hybrid.rawValue]
    // 2015/09/27 Xcode 7A220: doesn't open on simulator 6 plus or 6s
    walk!.mapItem().openInMaps(launchOptions: launchOptions)
  }
  
}
