
import UIKit

@IBDesignable class CardView: UIView {
  
  var rectForGraphImage: CGRect {
    return self.bounds
  }
  
  var stock: Stock = Stock(companyName: "Google", tickerSymbol: "GOOG", last5days: [657.50, 664.56, 661.43, 659.66, 658.27])
  
  let graphGenerator = GraphGenerator(settings: CardGraphGeneratorSettings())
  
  override func draw(_ rect: CGRect) {
    
    graphGenerator.draw(self.rectForGraphImage, with: self.stock.last5days)
    
  }
  
  
}
