
import Foundation

/**
 * This is a request model that defines Group search criteria
 * based on Find/Group API of api.meetup.com
 * http://www.meetup.com/meetup_api/docs/find/groups/
 **/
class MeetupGroupRequestModel {
  
  /// Approximate longitude.
  let longitude: Double
  
  /// Approximate latitude
  let latitude: Double
  
  /// Radius in miles. May be 0.0-100.0. Default is 50.0.
  let radius: Double
  
  /// Number of results in the response. Default is 50.
  let pages: Int
  
  /// Raw full text search query
  let searchText: String?
  
  init(latitude: Double, longitude: Double, radius: Double = 50.0, pages: Int = 50, searchText: String?) {
    self.longitude = longitude
    self.latitude = latitude
    self.radius = radius
    self.pages = pages
    self.searchText = searchText
  }
  
}
