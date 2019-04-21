
import UIKit

class MoviesTableViewController: UITableViewController {
  
  lazy var dataSource: NSArray = TicketOffice.sharedInstance.movies
  
  // MARK: - UITableViewDataSource
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return dataSource.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let section = dataSource[section] as? NSDictionary,
      let moviesInSection = section["movies"] as? NSArray {
        return moviesInSection.count
    }
    return 0
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if let sectionDictionary = dataSource[section] as? NSDictionary,
      let time = sectionDictionary["time"] as? String {
        return time
    }
    return ""
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell
    if let movie = movieForIndexPath(indexPath) {
      cell.movie = movie
    }
    return cell
  }
  
  private func movieForIndexPath(_ indexPath: IndexPath) -> Movie? {
    if let section = dataSource[(indexPath as NSIndexPath).section] as? NSDictionary,
      let moviesInSection = section["movies"] as? NSArray,
      let movie = moviesInSection[(indexPath as NSIndexPath).row] as? NSDictionary,
      let sectionDictionary = dataSource[(indexPath as NSIndexPath).section] as? NSDictionary,
      let time = sectionDictionary["time"] as? String  {
        return Movie(dictionary: movie, time: time)
    }
    return nil
  }
  
  // MARK: - Segue
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "SegueMovieDetail",
      let indexPath = tableView.indexPathForSelectedRow,
      let cell = tableView.cellForRow(at: indexPath) as? MovieTableViewCell,
      let movie = cell.movie,
      let destination = segue.destination as? MovieDetailViewController {
          destination.movie = movie
    }
  }
  
}

