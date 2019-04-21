
import WatchKit

class MovieRowController: NSObject {
  var movie: Movie! {
    didSet {
      movieTitle.setText("\(movie.time) \(movie.title)")
    }
  }
  
  @IBOutlet weak var movieTitle: WKInterfaceLabel!
}
