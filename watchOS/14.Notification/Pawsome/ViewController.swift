import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 100, height: 100)
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20)
    collectionView.collectionViewLayout = layout
    collectionView.delegate = self
    collectionView.dataSource = self
  }
  
  // MARK: - UICollectionViewDataSource
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 20
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: CatPhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatCell", for: indexPath) as! CatPhotoCell
    let catImageName = String(format: "cat%02d", arguments: [(indexPath as NSIndexPath).row + 1])
    cell.imageView.image = UIImage(named: catImageName)
    return cell
  }
  
  // MARK: - Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "PhotoViewerSegue" {
      if let photoViewer = segue.destination as? PhotoViewController, let cell = sender as? CatPhotoCell {
        photoViewer.image = cell.imageView.image
        
      }
    }
  }
  
}

