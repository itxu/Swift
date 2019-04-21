
import UIKit

extension UIColor {
  
  var hexString: String {
    
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    
    self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
    let intRed = UInt(red * 255)
    let intGreen = Int(green * 255)
    let intBlue = Int(blue * 255)

    let hex = String(format: "%02lx%02lx%02lx", intRed, intGreen, intBlue)
    
    return hex;
  }
}
