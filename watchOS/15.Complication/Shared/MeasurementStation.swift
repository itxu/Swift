
import UIKit

final class MeasurementStation: NSObject {
  let id: String
  let name: String
  let state: String
  
  required init(id: String, name: String, state: String) {
    self.id = id
    self.name = name
    self.state = state
  }
}

// MARK: NSCoding
extension MeasurementStation: NSCoding {
  private struct CodingKeys {
    static let id = "id"
    static let name = "name"
    static let state = "state"
  }
  
  convenience init(coder aDecoder: NSCoder) {
    let id = aDecoder.decodeObject(forKey: CodingKeys.id) as! String
    let name = aDecoder.decodeObject(forKey: CodingKeys.name) as! String
    let state = aDecoder.decodeObject(forKey: CodingKeys.state) as! String
    self.init(id: id, name: name, state: state)
  }
  
  func encode(with encoder: NSCoder) {
    encoder.encode(id, forKey: CodingKeys.id)
    encoder.encode(name, forKey: CodingKeys.name)
    encoder.encode(state, forKey: CodingKeys.state)
  }
}

// MARK: Loading
extension MeasurementStation {
  class func allStations() -> [MeasurementStation] {
    guard let file = Bundle.main.path(forResource: "Stations", ofType: "plist") else { return [] }
    guard let stationStrings = NSArray(contentsOfFile: file) as? [String] else { return [] }
    
    let stations = stationStrings.map { s -> MeasurementStation in
      let components = (s as NSString).components(separatedBy: ",")
      return MeasurementStation(id: components[0], name: components[1], state: components[2])
    }
    
    return stations
  }
}
