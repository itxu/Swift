
import Foundation

/**
 * MeetupRequestManager is responsible to dispatch requests, parse responses
 * and return objects fully formatted for UI.
 **/
class MeetupRequestManager: NetworkRequestManager {
  
  /// Dispatches a requet to get meetup groups. Upon success in the completion block returns a valid, non-nil array of meetups which can be empty. If fails, meetups array is nil. Check the error parameter for possible error messages.
  func fetchMeetupGroupsWithModel(model requestModel: MeetupGroupRequestModel, completion: @escaping (_ meetups: [Meetup]?, _ error: Error?) -> Void) {
    print("MeetupRequestManager made a request for location (lat: \(requestModel.latitude), lon: \(requestModel.longitude))")
    let request = MeetupRequestFactory().URLRequestForGroupSearchWithModel(requestModel)
    dispatchRequest(request) { (data, error) -> Void in
      guard let data = data else {
        let description = error?.localizedDescription ?? "nil"
        print("MeetupRequestManager failed to get valid response: \(description)")
        self.performBlockOnTheMainThread({ () -> Void in
          completion(nil, error)
        })
        return
      }
      let binder = MeetupGroupResponseBinder()
      let meetups = binder.bindResponse(data)
      if meetups.isEmpty {
        if let rawResponse = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
          print(rawResponse)
        }
      }
      self.performBlockOnTheMainThread({ () -> Void in
        completion(meetups, nil)
      })
    }
  }
}
