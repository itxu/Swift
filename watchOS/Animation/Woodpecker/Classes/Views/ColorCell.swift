

import UIKit

class ColorCell: UICollectionViewCell {
  static let ReuseId = "ColorCell"
  @IBOutlet weak var selectionView: UIView!
  
  override func awakeFromNib() {
    selectionView.layer.borderColor = UIColor.white.cgColor
    selectionView.layer.borderWidth = 4
  }
  
  func setColor(_ color: UIColor) {
    backgroundColor = color
  }
  
  override var isSelected: Bool {
    didSet {
      selectionView.isHidden = !isSelected
    }
  }
}
