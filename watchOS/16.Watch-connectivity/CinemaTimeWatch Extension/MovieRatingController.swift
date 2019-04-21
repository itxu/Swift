
import WatchKit
import Foundation
import WatchConnectivity

class MovieRatingController: WKInterfaceController {
  
  var movie: Movie!
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    if let movie = context as? Movie {
      self.movie = movie
      setTitle(movie.title)
    }
  }
  
  @IBAction func oneStarWasTapped() {
    rateMovieWithRating("★☆☆☆☆")
  }
  
  @IBAction func twoStarWasTapped() {
    rateMovieWithRating("★★☆☆☆")
  }
  
  @IBAction func threeStarWasTapped() {
    rateMovieWithRating("★★★☆☆")
  }
  
  @IBAction func fourStarWasTapped() {
    rateMovieWithRating("★★★★☆")
  }
  
  @IBAction func fiveStarWasTapped() {
    rateMovieWithRating("★★★★★")
  }
  
  private func rateMovieWithRating(_ rating: String) {
    TicketOffice.sharedInstance.rateMovie(movie.id, rating: rating)
    sendRatingToPhone(rating)
    pop()
  }
}

// MARK: - Watch Connectivity

extension MovieRatingController {
  
  func sendRatingToPhone(_ rating: String) {
    // TODO: Update to send movie ratings to phone
  }
}
