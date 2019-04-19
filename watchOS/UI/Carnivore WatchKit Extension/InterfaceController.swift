import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
  @IBOutlet weak var timer: WKInterfaceTimer!
  @IBOutlet weak var weightLabel: WKInterfaceLabel!
  @IBOutlet weak var timerButton: WKInterfaceButton!
  
  @IBOutlet weak var cookLabel: WKInterfaceLabel!
  
  var ounces = 16
  var cookTemp = MeatTemperature.medium
  var timerRunning = false
  var usingMetric = false
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    
    updateConfiguration()
  }
  
  func updateConfiguration() {
    // 1
    cookLabel.setText(cookTemp.stringValue)
    
    var weight = ounces
    var unit = "oz"
    
    if usingMetric {
      // 2
      let grams = Double(ounces) * 28.3495
      weight = Int(grams)
      unit = "gm"
    }
    
    // 3
    weightLabel.setText("Weight: \(weight) \(unit)")
  }
  
  @IBAction func onTempChange(_ value: Float) {
    if let temp = MeatTemperature(rawValue: Int(value)) {
      cookTemp = temp
      updateConfiguration()
    }
  }
  
  @IBAction func onPlusButton() {
    ounces += 1
    updateConfiguration()
  }
  
  @IBAction func onMinusButton() {
    ounces -= 1
    updateConfiguration()
  }
  
  @IBAction func onTimerButton() {
    // 1
    if timerRunning {
      timer.stop()
      timerButton.setTitle("Start Timer")
    } else {
      // 2
      let time = cookTemp.cookTimeForOunces(ounces)
      timer.setDate(Date(timeIntervalSinceNow: time))
      timer.start()
      timerButton.setTitle("Stop Timer")
    }
    // 3
    timerRunning = !timerRunning
    
    scroll(to: timer, at: .top, animated: true)
  }
  
  override func interfaceOffsetDidScrollToTop() {
    print("User scrolled to top")
  }
  
  override func interfaceDidScrollToTop() {
    print("User went to top by tapping status bar")
  }
  
  override func interfaceOffsetDidScrollToBottom() {
    print("User scrolled to bottom")
  }
  
  @IBAction func onMetricChanged(_ value: Bool) {
    usingMetric = value
    updateConfiguration()
  }
}
