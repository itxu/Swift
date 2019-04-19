import Foundation

enum MeatTemperature: Int {
  case rare = 0, mediumRare, medium, wellDone

  var stringValue: String {
    let temperatures = ["Rare", "Medium Rare", "Medium", "Well Done"]
      return temperatures[self.rawValue]
  }

  var timeModifier: Double {
    let modifiers = [0.5, 0.75, 1.0, 1.5]
    return modifiers[self.rawValue]
  }

  func cookTimeForOunces(_ ounces: Int) -> TimeInterval {
    let baseTime: TimeInterval = 47 * 60
    let baseWeight = 16
    let weightModifier: Double =
    Double(ounces) / Double(baseWeight)
    let tempModifier = self.timeModifier
    return baseTime * weightModifier * tempModifier
  }
}
