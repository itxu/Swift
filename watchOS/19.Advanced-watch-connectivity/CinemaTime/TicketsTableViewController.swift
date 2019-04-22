

import UIKit

class TicketsTableViewController: UITableViewController {
  
  var dataSource = [Movie]()
  lazy var notificationCenter: NotificationCenter = {
    return NotificationCenter.default
    }()
  var notificationObserver: NSObjectProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()
	
    tableView.estimatedRowHeight = UITableViewAutomaticDimension
    tableView.rowHeight = UITableViewAutomaticDimension
    notificationObserver = notificationCenter.addObserver(forName: NSNotification.Name(rawValue: NotificaitonPurchasedMovieOnWatch), object: nil, queue: nil) { (notification:Notification) -> Void in
      self.updateDisplay()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.updateDisplay()
  }
  
  private func updateDisplay() {
    DispatchQueue.main.async { () -> Void in
      if let movies = TicketOffice.sharedInstance.purchasedMovies() {
        self.dataSource = movies
        self.tableView.reloadData()
      }
    }
  }
  
  deinit {
    if let observer = notificationObserver {
      notificationCenter.removeObserver(observer)
    }
  }
  
  // MARK: - UITableViewDataSource
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CellPurchasedMovie", for: indexPath) as! MovieTableViewCell
    let movie = dataSource[(indexPath as NSIndexPath).row]
    cell.movie = movie
    return cell
  }
  
  // MARK: - Segue
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "SeguePurchasedToMovieDetail",
      let indexPath = tableView.indexPathForSelectedRow,
      let cell = tableView.cellForRow(at: indexPath) as? MovieTableViewCell,
      let movie = cell.movie,
      let destination = segue.destination as? MovieDetailViewController {
        destination.movie = movie
    }
  }
  
}
