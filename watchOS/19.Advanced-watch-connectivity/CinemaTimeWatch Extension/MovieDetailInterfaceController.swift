
import WatchKit
import Foundation
import WatchConnectivity

class MovieDetailInterfaceController: WKInterfaceController {
  
  @IBOutlet var movieTitle: WKInterfaceLabel!
  @IBOutlet var time: WKInterfaceLabel!
  @IBOutlet var director: WKInterfaceLabel!
  @IBOutlet var actors: WKInterfaceLabel!
  @IBOutlet var rating: WKInterfaceLabel!
  @IBOutlet var synopsis: WKInterfaceLabel!
  @IBOutlet var buyButton: WKInterfaceButton!
  @IBOutlet var movieTicket: WKInterfaceImage!
  
  var movie: Movie!
    
  lazy var documentsDirectory: String = {
    return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
    }()
  
  lazy var movieTicketFilePath: String = { [unowned self] in
    return self.documentsDirectory + "/QR\(self.movie.id).png"
    }()
  
  var movieTicketImage: UIImage? {
    get {
      return UIImage(contentsOfFile: self.movieTicketFilePath)
    }
  }
  
  // MARK: - Lifecycle
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    
    if let context = context as? Movie {
      movie = context
      
      setTitle(movie.title)
      movieTitle.setText(movie.title)
      time.setText(movie.time)
      director.setText(movie.director)
      actors.setText(movie.actors)
      synopsis.setText(movie.synopsis)
      
      if TicketOffice.sharedInstance.movieTicketIsAlreadyPurchased(movie.id) {
        buyButton.setHidden(true)
        if let image = movieTicketImage {
          self.movieTicket.setImage(image)
        } else {
          requestTicketForPurchasedMovie(movie)
        }
      } else {
        buyButton.setHidden(false)
      }
    }
  }
  
  override func didAppear() {
    super.didAppear()
    rating.setText(TicketOffice.sharedInstance.movieRatingForID(movie.id))
  }
  
  // MARK: - Segue
  
  override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
    return movie
  }
  
  // MARK:
  
  func saveMovieTicketAndUpdateDisplay(_ movieTicket: Data) {
    DispatchQueue.main.async(execute: { () -> Void in
      do {
        try movieTicket.write(to: URL(fileURLWithPath: self.movieTicketFilePath))
      } catch {
        print("ERROR: Could not write to \(self.movieTicketFilePath)")
      }
      self.movieTicket.setImage(self.movieTicketImage)
    })
  }
  
  func showReachabilityError() {
    let tryAgain = WKAlertAction(title: "Try Again", style: .default, handler: { () -> Void in })
    let cancel = WKAlertAction(title: "Cancel", style: .cancel, handler: { () -> Void in })
    self.presentAlert(withTitle: "Your iPhone is not reachable.", message: "You movie ticket cannot be shown because your iPhone is not currently connected to your phone. Please ensure your iPhone is on and within range of your Watch.", preferredStyle: WKAlertControllerStyle.alert, actions:[tryAgain, cancel])
  }
}

// MARK: - Watch Connectivity

extension MovieDetailInterfaceController {

  func requestTicketForPurchasedMovie(_ movie: Movie) {
    // 1
    if WCSession.isSupported() {
      // 2
      let session = WCSession.default
      if session.isReachable {
        // 3
        let message = ["movie_id":movie.id]
        session.sendMessage(message, replyHandler: { (reply:[String : Any]) -> Void in
          // 4
          if let movieID = reply["movie_id"] as? String,
            let movieTicket = reply["movie_ticket"] as? Data
            , movieID == self.movie.id {
            // 5
            self.saveMovieTicketAndUpdateDisplay(movieTicket)
            
          }
          }, errorHandler: { (error:Error) in
            print("ERROR: \(error.localizedDescription)")
        })
      } else { // reachable
        self.showReachabilityError()
      }
    }
  }
}
