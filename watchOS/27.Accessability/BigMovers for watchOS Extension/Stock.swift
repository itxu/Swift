
import WatchKit

class Stock {
  let companyName: String
  let tickerSymbol: String
  let last5days: [Double]
  
  let numberFormatter = NumberFormatter()
  
  var change: Double {
    let first = last5days.first!
    let last = last5days.last!
    return last - first
  }
  var changePercent: Double {
    return change / last5days.first!
  }
  var changePercentAsString: String {
    numberFormatter.numberStyle = .percent
    numberFormatter.minimumFractionDigits = 2
    numberFormatter.maximumFractionDigits = 2
    return numberFormatter.string(from: NSNumber(value:
      changePercent))!
  }
  var changeCharacter: String {
    return change > 0 ? "△" : "▽"
  }
  var changeColor: UIColor {
    return change > 0 ? UIColor(hex: 0x4CD964) : UIColor(hex: 0xFF3B30)
  }
  var minPriceAsString: String {
    numberFormatter.numberStyle = .currency
    numberFormatter.maximumFractionDigits = 0
    return numberFormatter.string(from: NSNumber(value:
      last5days.min()!))!
  }
  var maxPriceAsString: String {
    numberFormatter.numberStyle = .currency
    numberFormatter.maximumFractionDigits = 0
    return numberFormatter.string(from: NSNumber(value: last5days.max()!))!
  }
  
  init(companyName: String, tickerSymbol: String, last5days: [Double]) {
    self.companyName = companyName
    self.tickerSymbol = tickerSymbol
    self.last5days = last5days
  }
  
}

var stocks = [
  Stock(companyName: "Google", tickerSymbol: "GOOG", last5days: [657.50, 664.56, 661.43, 659.66, 658.27]),
  Stock(companyName: "Tesla", tickerSymbol: "TSLA", last5days: [266.15, 266.79, 263.82, 264.82, 253.01]),
  Stock(companyName: "Apple", tickerSymbol: "AAPL", last5days: [121.30, 122.37,	122.99, 123.38, 122.77]),
  Stock(companyName: "Facebook", tickerSymbol: "FB", last5days: [94.01, 95.21,	96.99, 95.29, 94.17]),
  Stock(companyName: "Amazon", tickerSymbol: "AMZN", last5days: [536.15, 536.76, 529.00, 526.03, 531.41])
]
