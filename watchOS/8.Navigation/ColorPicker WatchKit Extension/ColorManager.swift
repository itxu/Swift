import UIKit

class ColorManager {
  static let defaultManager = ColorManager()
  
  let availableColors = [
    UIColor(red: 0.941176471, green: 0.098039216, blue: 0.08627451, alpha: 1),
    UIColor(red: 0.984313725, green: 0.6, blue: 0, alpha: 1),
    UIColor(red: 0.952941176, green: 0.933333333, blue: 0, alpha: 1),
    UIColor(red: 0, green: 0.603921569, blue: 0.266666667, alpha: 1),
    UIColor(red: 0.215686275, green: 0.317647059, blue: 0.650980392, alpha: 1),
    UIColor(red: 0.780392157, green: 0.094117647, blue: 0.568627451, alpha: 1)
  ]
  var selectedColor: UIColor
  
  init() {
    selectedColor = availableColors.first!
  }
}

public extension UIColor {
  var hexString: String {
    var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
    getRed(&r, green: &g, blue: &b, alpha: nil)
    
    let strings: [String] = [r, g, b].map { f in
      let i = Int(f * 255.0)
      let str = NSString(format: "%2X", i).trimmingCharacters(in: CharacterSet.whitespaces)
      if str.characters.count == 1 {
        return "0" + str
      } else {
        return str
      }
    }
    
    return strings.reduce("", { return $0 + $1 })
  }
  
  var rgbString: String {
    var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
    getRed(&r, green: &g, blue: &b, alpha: nil)
    r *= 255
    g *= 255
    b *= 255
    return "r: \(Int(r)), g: \(Int(g)), b: \(Int(b))"
  }
  
  var hslString: String {
    var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0
    getHue(&h, saturation: &s, brightness: &b, alpha: nil)
    h *= 360
    s *= 100
    b *= 100
    return "h: \(Int(h)), s: \(Int(s))%, l: \(Int(b))%"
  }
  
  private func adjust(amount: CGFloat) -> UIColor {
    var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
    if getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
      return UIColor(hue: h,
                     saturation: a,
                     brightness: min(1, max(0, b * amount)),
                     alpha: a)
    } else {
      return self
    }
  }
  
  func lighterColor() -> UIColor {
    return adjust(amount: 1.25)
  }
  
  func darkerColor() -> UIColor {
    return adjust(amount: 0.75)
  }
  
}
