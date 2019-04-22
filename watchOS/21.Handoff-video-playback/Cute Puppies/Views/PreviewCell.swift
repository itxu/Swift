
import UIKit
import AVFoundation

class PreviewCell: UICollectionViewCell {
  
  // MARK: Public - properties
  
  /// The default cell identifier set in the interface builder, for convenience.
  static let IBIdentifier = "PreviewCellIdentifier"
  
  /// The asset to be displayed by the receiver.
  var asset: AVAsset? {
    didSet {
      updateImageView()
    }
  }
  
  var footnote: String? {
    didSet {
      textLabel.text = footnote
    }
  }
  
  // MARK: Private - properties
  
  @IBOutlet private var textLabel: UILabel!
  @IBOutlet private var imageView: UIImageView!
  @IBOutlet private var loadingIndicator: UIActivityIndicatorView!
  @IBOutlet private var playIcon: UIImageView!
  
  // MARK: Life Cycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    loadingIndicator.startAnimating()
  }
  
  // MARK: Private
  
  /// Updates the poster image from the asset property of the receiver.
  private func updateImageView() {
    
    guard  let asset = self.asset else {
      imageView.image = nil
      loadingIndicator.stopAnimating()
      playIcon.isHidden = true
      return
    }
    
    loadingIndicator.startAnimating()
    
    VideoUtilities.snapshot(fromMovie: asset, resizeTo: VideoUtilities.OriginalSize) { (image) in
      self.loadingIndicator.stopAnimating()
      self.playIcon.isHidden = false
      self.imageView.image = image
    }
  }
}
