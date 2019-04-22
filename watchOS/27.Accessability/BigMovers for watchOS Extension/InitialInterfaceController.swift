
import WatchKit
import Foundation


class InitialInterfaceController: WKInterfaceController {
  
  override init() {
    super.init()
    
    stocks = stocks.sorted {
      abs($0.changePercent) > abs($1.changePercent)
    }
    
    let names = [String](repeating: "PageInterfaceController", count: stocks.count)
    WKInterfaceController.reloadRootControllers(withNames: names, contexts: stocks)
  }
  
}
