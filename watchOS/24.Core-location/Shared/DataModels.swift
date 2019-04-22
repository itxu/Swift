
import Foundation
import UIKit

struct Coordinate {
  let longitude: Double
  let latitude: Double
}

struct Location {
  let country: String
  let state: String
  let city: String
}

struct Organizer {
  let name: String
}

struct Category {
  let name: String
}

struct Group {
  let name: String
  /// Formatted number of members.
  let numberOfMembers: String
  let description: String
  let color: UIColor
}

struct Event {
  let name: String
}

class Meetup {
  let organizer: Organizer
  let group: Group
  let coordinate: Coordinate
  let location: Location
  let nextEvent: Event
  let category: Category
  let link: URL
  
  init(organizer: Organizer, group: Group, coordinate: Coordinate, location: Location, nextEvent: Event, category: Category, link: URL) {
    self.organizer = organizer
    self.group = group
    self.coordinate = coordinate
    self.location = location
    self.nextEvent = nextEvent
    self.category = category
    self.link = link
  }
}
