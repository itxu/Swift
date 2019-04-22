
import Foundation

let dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  
  formatter.dateStyle = .short
  formatter.timeStyle = .short
  
  formatter.doesRelativeDateFormatting = true
  
  return formatter
} ()

let dateOnlyFormatter: DateFormatter = {
  let formatter = DateFormatter()
  
  formatter.dateStyle = .short
  formatter.timeStyle = .none
  
  formatter.doesRelativeDateFormatting = true
  
  return formatter
} ()


let timeOnlyFormatter: DateFormatter = {
  let formatter = DateFormatter()
  
  formatter.dateStyle = .none
  formatter.timeStyle = .short
  
  formatter.doesRelativeDateFormatting = true
  
  return formatter
} ()


let elapsedTimeFormatter: DateComponentsFormatter = {
  let formatter = DateComponentsFormatter()
  
  formatter.unitsStyle = .abbreviated
  formatter.collapsesLargestUnit = true
  
  return formatter
} ()

let dateIntervalFormatter: DateIntervalFormatter = {
  let formatter = DateIntervalFormatter()
  
  formatter.timeStyle = .short
  
  return formatter
} ()

let numberFormatter = NumberFormatter()

let calorieFormatter: EnergyFormatter = {
  let formatter = EnergyFormatter()

  formatter.isForFoodEnergyUse = true
  formatter.numberFormatter = numberFormatter
  
  return formatter
} ()

let distanceFormatter = LengthFormatter()

