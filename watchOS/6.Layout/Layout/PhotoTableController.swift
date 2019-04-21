import UIKit

class PhotoTableController: UITableViewController {
  
  let photos = Photo.samplePhotos
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    if let destination = segue.destination as? PhotoDetailController,
      let indexPath = tableView.indexPathForSelectedRow, segue.identifier == "PhotoDetailSegue" {
      destination.photo = photos[(indexPath as NSIndexPath).row]
    }
  }
  
  
  //MARK: UITableViewDataSource
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return photos.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableCell", for: indexPath)
    let photo = photos[(indexPath as NSIndexPath).row]
    if let cell = cell as? PhotoTableCell {
      cell.photoView.image = UIImage(named: photo.imageName)
      cell.usernameLabel.text = photo.username
      cell.timeLabel.text = photo.timePosted
      cell.commentLabel.text = photo.comment
    }
    return cell
  }
  
}
