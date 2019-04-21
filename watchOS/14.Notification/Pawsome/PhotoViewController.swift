import UIKit

class PhotoViewController: UIViewController {
  
  var image: UIImage? = UIImage()
  @IBOutlet weak var imageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.image = image
  }
  
  @IBAction func didTap(_ sender: UITapGestureRecognizer) {
    dismiss(animated: true, completion: nil)
  }
}
