
import WatchKit
import Foundation

class TicketsController: WKInterfaceController {
  
  @IBOutlet var table: WKInterfaceTable!
  @IBOutlet var loading: WKInterfaceLabel!
  
  override func willActivate() {
    super.willActivate()
    updateDisplay()
  }
  
  private func updateDisplay() {
    loading.setHidden(false)
    if let purchasedMovieTickets = TicketOffice.sharedInstance.purchasedMovies() {
      let numberOfMovies = purchasedMovieTickets.count
      table.setNumberOfRows(numberOfMovies, withRowType: "MovieRowType")
      for index in 0...(numberOfMovies-1) {
        if let controller = table.rowController(at: index) as? MovieRowController {
          let movie = purchasedMovieTickets[index]
          controller.movie = movie
        }
      }
    }
    loading.setHidden(true)
  }
  
  // MARK: - Segue
  
  override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
    if let rowController = table.rowController(at: rowIndex) as? MovieRowController {
      return rowController.movie
    }
    return nil
  }
}
