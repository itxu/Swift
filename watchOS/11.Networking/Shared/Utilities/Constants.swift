
import Foundation
import UIKit

let dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  
  formatter.dateFormat = "yyyy-MM-dd"
  
  return formatter
  } ()

let numberFormatter: NumberFormatter = {
  let formatter = NumberFormatter()
  
  formatter.maximumFractionDigits = 1
  
  return formatter
  } ()

let commaFormatter: NumberFormatter = {
  let formatter = NumberFormatter()
  
  formatter.maximumFractionDigits = 0
  formatter.usesGroupingSeparator = true
  
  return formatter
  } ()

let femaleColor = UIColor(red: 1.0, green: 0x22/0xff, blue: 0x67/0xff, alpha: 1.0)
let maleColor = UIColor(red: 0x29/0xff, green: 0x94/0xff, blue: 0xf4/0xff, alpha: 1.0)
