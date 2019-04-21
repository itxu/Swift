import UIKit

class RecipeCell: UITableViewCell {

  @IBOutlet weak var thumbnailView: UIImageView!
  @IBOutlet weak var recipeLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()

    thumbnailView.layer.borderWidth = 1 / UIScreen.main.scale
    thumbnailView.layer.borderColor = UIColor(white: 0.9, alpha: 1).cgColor
  }

}