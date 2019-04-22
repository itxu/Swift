
import Foundation
import MapKit
import UIKit

extension CGFloat {
  func imperial() -> CGFloat {
    return self * 0.621371192
  }
  
  func fraction() -> CGFloat {
    let (_, c_fractional) = modf(self)
    return c_fractional
  }
}

extension UIColor {
  convenience init(colorArray array: NSArray) {
    let r = array[0] as! CGFloat
    let g = array[1] as! CGFloat
    let b = array[2] as! CGFloat
    self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha:1.0)
  }
}

final class Walk: NSObject {
  let walkTitle: String
  let shortName: String  // unused option for Watch app
  let location: String
  let goal: CGFloat
  let info: String
  let imageName: String
  var mapCoordinates: CLLocationCoordinate2D
  
  func completions(_ distance: CGFloat) -> CGFloat {
    return distance / goal
  }
  
  static let progressColors = [UIColor(colorArray: [117, 194, 35]), UIColor(colorArray: [255, 195, 10]),
    UIColor(colorArray: [253, 32, 37]), UIColor(colorArray: [128, 0, 255])]
  class func progressIndex(_ fraction: CGFloat) -> Int {
    if fraction <= 0.25 {
      return 0
    } else if fraction <= 0.50 {
      return 1
    } else if fraction <= 0.75 {
      return 2
    } else {
      return 3
    }
  }
  
  init(walkTitle: String, shortName: String, location: String, goal: CGFloat, info: String, imageName: String, mapCoordinates: CLLocationCoordinate2D) {
    self.walkTitle = walkTitle
    self.shortName = shortName
    self.location = location
    self.goal = goal
    self.info = info
    self.imageName = imageName
    self.mapCoordinates = mapCoordinates
  }
  
  class func convertDictToWalk(_ dict: [String: AnyObject]) -> Walk {
    let walkTitle = dict["title"] as! String
    let shortName = dict["shortName"] as! String
    let location = dict["location"] as! String
    let goal = dict["goal"] as! CGFloat
    let info = dict["info"] as! String
    let imageName = dict["imageName"] as! String
    let mapCoordinatesDict = dict["mapCoordinates"] as! NSDictionary
    let latitude = mapCoordinatesDict["latitude"] as! CLLocationDegrees
    let longitude = mapCoordinatesDict["longitude"] as! CLLocationDegrees
    let mapCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    return Walk(walkTitle: walkTitle, shortName: shortName, location: location, goal: goal, info: info, imageName: imageName, mapCoordinates: mapCoordinates)
  }
  
}
