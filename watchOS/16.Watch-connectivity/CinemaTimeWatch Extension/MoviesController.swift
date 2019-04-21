
import WatchKit
import Foundation


class MoviesController: WKInterfaceController {
  
  @IBOutlet var table: WKInterfaceTable!
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    updateDisplay()
  }
  
  private func updateDisplay() {
    let movies = TicketOffice.sharedInstance.allMovies
    
    let numberOfMovies = movies.count
    table.setNumberOfRows(numberOfMovies, withRowType: "MovieRowType")
    
    for index in 0...(numberOfMovies-1) {
      if let controller = table.rowController(at: index) as? MovieRowController {
        let movie = movies[index]
        controller.movie = movie
      }
    }
    
  }
  
  // MARK: - Segue
  
  override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
    if let rowController = table.rowController(at: rowIndex) as? MovieRowController {
      return rowController.movie
    }
    return nil
  }
}
