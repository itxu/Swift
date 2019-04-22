
import Foundation

/**
 * This is a request factory that creates NSURLRequest to query api.meetup.com
 * using request models in which search parameters are defined.
 * The factory puts together query pamateres with based URL, API key and anything
 * else necessary.
 **/
class MeetupRequestFactory {
  
  private let APIKey = "YOUR_API_TOKEN"
  private let MeetupBaseURL = "https://api.meetup.com/"
  
  /// API Methods.
  private enum Method: String {
    case FindGroup = "find/groups"
  }
  
  /// Returns a NSURLRequest to query https://api.meetup.com/find/groups endpoint.
  func URLRequestForGroupSearchWithModel(_ model: MeetupGroupRequestModel) -> URLRequest {
    
    if APIKey == "YOUR_API_TOKEN" {
      print("\n\nMeetupRequestFactory encountered error: Invalid API token.\nYou need to set your own valid private API token for Meetup.com.\n\n")
      let name = NSExceptionName(rawValue: "Invalid API token")
      NSException.raise(name, format: "Error: %@", arguments: getVaList([]))
    }
    
    let base = baseURLWithMethod(.FindGroup)
    
    var URLString = base
    URLString += "&key=\(APIKey)"
    URLString += "&lon=\(model.longitude)"
    URLString += "&lat=\(model.latitude)"
    URLString += "&radius=\(model.radius)"
    URLString += "&page=\(model.pages)"
    if let searchText = model.searchText {
      URLString += "&text=\(searchText)"
    }
    
    let URL = Foundation.URL(string: URLString)!
    let request = URLRequest(url: URL, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30.0)
    return request
  }
  
  private func baseURLWithMethod(_ method: Method) -> String {
    let output = MeetupBaseURL + method.rawValue + "?&"
    return output
  }
  
}
