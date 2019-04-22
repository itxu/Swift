
import UIKit
import WatchConnectivity

class MovieDetailViewController: UIViewController {
  
  @IBOutlet weak var poster: UIImageView!
  @IBOutlet weak var movieTitle: UILabel!
  @IBOutlet weak var synopsis: UILabel!
  @IBOutlet weak var time: UILabel!
  @IBOutlet weak var director: UILabel!
  @IBOutlet weak var actors: UILabel!
  @IBOutlet weak var rating: UIButton!
  @IBOutlet weak var buyTicketButton: UIButton!
  @IBOutlet weak var QRImageView: UIImageView!
  
  var movie: Movie!
  lazy var notificationCenter: NotificationCenter = {
    return NotificationCenter.default
    }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = movie.title
    movieTitle.text = movie.title
    time.text = movie.time
    synopsis.text = movie.synopsis
    poster.image = UIImage(named: movie.poster)
    director.text = movie.director
    actors.text = movie.actors
    rating.setTitle(TicketOffice.sharedInstance.movieRatingForID(movie.id), for: UIControlState())
    if TicketOffice.sharedInstance.movieTicketIsAlreadyPurchased(movie.id) {
        let qrCode = QRCode(movie.id)
        QRImageView.image = qrCode?.image
        buyTicketButton.isHidden = true
    } else {
        QRImageView.isHidden = true
    }
  }
  
  @IBAction func butTicketWasTapped(_ sender: UIButton) {

    let alert = UIAlertController(title: "Purchase Ticket", message: "Are you sure you want to purchase 1 ticket for $8.50?", preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(cancelAction)
    
    let buyAction = UIAlertAction(title: "Buy", style: .default) {
      (action:UIAlertAction) -> Void in
      let ticketOffice = TicketOffice.sharedInstance
      ticketOffice.purchaseTicketForMovie(self.movie.id)
      
      
      DispatchQueue.main.async { () -> Void in
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(rawValue: NotificationPurchasedMovieOnPhone), object: self.movie.id)
      }
      
      _ = self.navigationController?.popToRootViewController(animated: true)
    }
    alert.addAction(buyAction)
    
    present(alert, animated: true, completion: nil)
  }
    
  @IBAction func ratingWasTapped(_ sender: UIButton) {
    
    let alert = UIAlertController(title: "Rate \(self.movie.title)", message: nil, preferredStyle: .actionSheet)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let oneAction = UIAlertAction(title: "★☆☆☆☆", style: .default) { (action:UIAlertAction) -> Void in
      self.rateMovieWithRating(action.title!)
    }
    let twoAction = UIAlertAction(title: "★★☆☆☆", style: .default) { (action:UIAlertAction) -> Void in
      self.rateMovieWithRating(action.title!)
    }
    let threeAction = UIAlertAction(title: "★★★☆☆", style: .default) { (action:UIAlertAction) -> Void in
      self.rateMovieWithRating(action.title!)
    }
    let fourAction = UIAlertAction(title: "★★★★☆", style: .default) { (action:UIAlertAction) -> Void in
      self.rateMovieWithRating(action.title!)
    }
    let fiveAction = UIAlertAction(title: "★★★★★", style: .default) { (action:UIAlertAction) -> Void in
      self.rateMovieWithRating(action.title!)
    }

    alert.addAction(oneAction)
    alert.addAction(twoAction)
    alert.addAction(threeAction)
    alert.addAction(fourAction)
    alert.addAction(fiveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
  
  private func rateMovieWithRating(_ rating: String) {
    TicketOffice.sharedInstance.rateMovie(movie.id, rating: rating)
    sendRatingToWatch(rating)
    self.rating.setTitle(rating, for: UIControlState())
  }

}

// MARK: - Watch Connectivity

extension MovieDetailViewController {
  
  func sendRatingToWatch(_ rating: String) {
    // 1
    if WCSession.isSupported() {
      // 2
      let session = WCSession.default
      if session.isWatchAppInstalled {
        // 3
        let userInfo = ["movie_id":movie.id, "rating":rating]
        session.transferUserInfo(userInfo)
      }
    }
  }
  
}
