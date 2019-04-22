
import Foundation

enum MainInterfaceState {
  case noContent
  case notAuthorized
  case meetupContent
  case error
}

class MainInterfaceModel {
  var state = MainInterfaceState.noContent
  var loading: Bool = false
  var meetups = [Meetup]()
}
