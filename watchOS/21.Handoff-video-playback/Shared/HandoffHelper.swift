
import Foundation

struct Version {
  let key: String
  let number: Int
}

struct Handoff {
  
  /// The registered user activity types in the application's Info.plist.
  enum Activity: String {
    
    /// View home page.
    case viewHome   = "com.razeware.cutepuppies.home"
    
    /// Index of a clip that's being played.
    case playClip   = "com.razeware.cutepuppies.clip"
    
    var stringValue: String {
      return self.rawValue
    }
  }
  
  /// Key to an associated value for an activity type in userInfo.
  /// For .viewHome, the value of this key is empty string.
  /// For .playClip, the value is the index of the clip.
  static let activityValueKey = "activityValue"
  
  /// Current version of Handoff. It indicates the assumed structure of Handoff and it's userInfo structure.
  static let version = Version(key: "version", number: 1)
}
