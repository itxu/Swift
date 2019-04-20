
import UIKit

class ImageCell: UITableViewCell {

  @IBOutlet internal weak var squareImageView: UIImageView!
  
  var graphImage: UIImage? {
    willSet(newImage) {
      squareImageView!.image = newImage
    }
  }

}
