
import WatchKit
import Foundation


@IBDesignable class PageInterfaceController: WKInterfaceController {
  
  var stock: Stock!
  
  var graphHeightRatio: CGFloat = 0.875 // default also set in interface builder
  var detailsHeightRatio: CGFloat = 0.125 // default also set in interface builder
  
  var screenSize: CGSize {
    return self.contentFrame.size // for convenience
  }
  
  @IBOutlet var graphImage: WKInterfaceImage!
  @IBOutlet var detailsGroup: WKInterfaceGroup!
  @IBOutlet var changeLabel: WKInterfaceLabel!
  @IBOutlet var tickerSymbolLabel: WKInterfaceLabel!
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    
    if let context = context as? Stock {
      self.stock = context
    }
    
  }
  
  override func willActivate() {
    super.willActivate()
    
    updateForAccessibility()
    
    changeLabel.setText("\(stock.changeCharacter) \(stock.changePercentAsString)")
    
    changeLabel.setTextColor(stock.changeColor)
    
    tickerSymbolLabel.setText(stock.tickerSymbol)
    
    generateImage()
  }
  
  func generateImage() {
	DispatchQueue.global(qos: .default).async {
    
      let graphGenerator = GraphGenerator(settings: WatchGraphGeneratorSettings())
      
      let height = self.graphHeightRatio * self.screenSize.height
      
      let graphRect = CGRect(x: 0, y: 0, width: self.screenSize.width, height: height)
      
      let image = graphGenerator.image(graphRect, with: self.stock.last5days)
      
      DispatchQueue.main.async {
        self.graphImage.setImage(image)
      }
    }
  }
  
  func updateForAccessibility() {
    if WKAccessibilityIsVoiceOverRunning() {
      makeLayoutAccessible()
      makeGraphAccessible()
      makeGroupAccessible()
    }
  }
  
  func makeLayoutAccessible() {
    graphHeightRatio = 0.6
    detailsHeightRatio = 0.4
    graphImage.setHeight(graphHeightRatio * screenSize.height)
    detailsGroup.setHeight(detailsHeightRatio * screenSize.height)
  }
  
  func makeGraphAccessible() {
    // 1
    var imageRegions: [WKAccessibilityImageRegion] = []
    // 2
    for index in 1..<stock.last5days.count { // skip the first day
      // 3
      let imageRegion = WKAccessibilityImageRegion()
      // 4
      imageRegion.frame = imageRegionFrameForTrailingIndex(index)
      // 5
      imageRegion.label = summaryForTrailingIndex(index)
      // 6
      imageRegions.append(imageRegion)
    }
    // 7
    graphImage.setAccessibilityImageRegions(imageRegions)
  }
  
  func makeGroupAccessible(){
    // 1
    detailsGroup.setIsAccessibilityElement(true)
    // 2
    let percentage = percentageChangeForVoiceOver(
      from: stock.last5days.first!, to: stock.last5days.last!)
    // 3
    let label =
      "\(stock.companyName), past five days, \(percentage)"
    // 4
    detailsGroup.setAccessibilityLabel(label)
    // 5
    detailsGroup.setAccessibilityTraits(
      UIAccessibilityTraitSummaryElement)
  }
  
  func imageRegionFrameForTrailingIndex(_ trailingIndex: Int) -> CGRect {
    let height = screenSize.height * graphHeightRatio
    let width =
      screenSize.width / CGFloat(stock.last5days.count - 1)
    let x = width * (CGFloat(trailingIndex) - 1)
    return CGRect(x: x, y: 0, width: width, height: height)
  }
  
  func summaryForTrailingIndex(_ trailingIndex: Int) -> String {
    let percentageDescription = percentageChangeForVoiceOver(from:
        stock.last5days[trailingIndex - 1],
      to: stock.last5days[trailingIndex])
    // 2
    var timeDescription = String()
    switch trailingIndex {
    case 1:
      timeDescription = "3 days ago"
    case 2:
      timeDescription = "day before yesterday"
    case 3:
      timeDescription = "yesterday"
    case 4:
      timeDescription = "today"
    default:
      break
    }
    // 3
    return "\(percentageDescription) \(timeDescription)"
  }
  
  func percentageChangeForVoiceOver(from previous: Double, to current: Double) -> String {
    // 1
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .percent
    numberFormatter.minimumFractionDigits = 2
    numberFormatter.maximumFractionDigits = 2
    // 2
    let change = (current - previous) / previous
    // 3
    let direction = change > 0 ? "up" : "down"
    // 4
    let percent = numberFormatter.string(from: NSNumber(value:
      abs(change)))!
    // 5
    return "\(direction) \(percent)"
  }
  
}
