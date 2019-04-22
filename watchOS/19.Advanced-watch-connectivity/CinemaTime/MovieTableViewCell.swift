
import UIKit

class MovieTableViewCell: UITableViewCell {
  @IBOutlet weak var poster: UIImageView!
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var synopsis: UILabel!
  
  var movie:Movie? {
    didSet {
      title.text = movie?.title
      synopsis.text = movie?.synopsis
      poster.image = UIImage(named: (movie?.poster)!)
    }
  }
}
