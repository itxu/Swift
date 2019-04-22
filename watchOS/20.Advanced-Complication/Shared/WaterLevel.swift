
import UIKit

@objc(WaterLevel)
final class WaterLevel: NSObject {
  private static let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    return dateFormatter
    }()
  
  let date: Date
  let height: Double
  
  // Calculated by TideConditions
  var situation: TideConditions.TideSituation
  
  init(date: Date, height: Double) {
    self.date = date
    self.height = height
    self.situation = .Unknown
    super.init()
  }
  
  convenience init?(json: [String: AnyObject]) {
    guard let dateString = json["t"] as? String, let heightString = json["v"] as? String else {
      return nil
    }
    
    guard let date = WaterLevel.dateFormatter.date(from: dateString), let height = Double(heightString) else {
      return nil
    }
    self.init(date: date, height: height)
  }
  
  override var description: String {
    return "WaterLevel: \(height)"
  }
}

// MARK: For Complication
extension WaterLevel {
  var shortTextForComplication: String {
    return String(format: "%.1fm", self.height)
  }
  
  var longTextForComplication: String {
    return String(format: "%@, %.1fm",self.situation.rawValue, self.height)
  }
}

// MARK: NSCoding
extension WaterLevel: NSCoding {
  private struct CodingKeys {
    static let date = "date"
    static let height = "height"
    static let situation = "situation"
  }
  
  convenience init(coder aDecoder: NSCoder) {
    let date = aDecoder.decodeObject(forKey: CodingKeys.date) as! Date
    let height = aDecoder.decodeDouble(forKey: CodingKeys.height)
    self.init(date: date, height: height)
    
    self.situation = TideConditions.TideSituation(rawValue: aDecoder.decodeObject(forKey: CodingKeys.situation) as! String)!
  }
  
  func encode(with encoder: NSCoder) {
    encoder.encode(date, forKey: CodingKeys.date)
    encoder.encode(height, forKey: CodingKeys.height)
    encoder.encode(situation.rawValue, forKey: CodingKeys.situation)
  }
}
