
import WatchKit
import Foundation

class MoviePurchaseConfirmationController: WKInterfaceController {
  
  var movie: Movie!
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    if let context = context as? Movie {
      movie = context
      setTitle(movie.title)
    }
  }
  
  @IBAction func buyButtonWasTapped() {
    TicketOffice.sharedInstance.purchaseTicketForMovie(movie.id)
    DispatchQueue.main.async { () -> Void in
      let notificationCenter = NotificationCenter.default
      notificationCenter.post(name: Notification.Name(rawValue: NotificationPurchasedMovieOnWatch), object: nil)
    }
    popToRootController()
  }
  
  @IBAction func cancelButtonWasTapped() {
    pop()
  }
  
}
