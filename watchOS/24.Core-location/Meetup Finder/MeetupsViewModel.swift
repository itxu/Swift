
import Foundation

enum MeetupsViewState {
  case initial
  case noContent
  case notAuthorized
  case meetupContent
}

class MeetupsViewModel {
  var state = MeetupsViewState.initial
  var meetups = [Meetup]()
}
