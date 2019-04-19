import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
  @IBOutlet weak var timer: WKInterfaceTimer!
  @IBOutlet weak var timerButton: WKInterfaceButton!
  @IBOutlet var weightPicker: WKInterfacePicker!
  @IBOutlet var temperatureLabel: WKInterfaceLabel!
  @IBOutlet var temperaturePicker: WKInterfacePicker!

  var ounces = 16
  var cookTemp = MeatTemperature.medium
  var timerRunning = false

  override func awake(withContext context: Any?) {
    super.awake(withContext: context)

    // 1
    var weightItems: [WKPickerItem] = []
    for i in 1...32 {
      // 2
      let item = WKPickerItem()
      item.title = String(i)
      weightItems.append(item)
    }
    // 3
    weightPicker.setItems(weightItems)
    // 4
    weightPicker.setSelectedItemIndex(ounces - 1)

    // 1
    var tempItems: [WKPickerItem] = []
    for i in 1...4 {
      // 2
      let item = WKPickerItem()
      item.contentImage = WKImage(imageName: "temp-\(i)")
      tempItems.append(item)
    }
    // 3
    temperaturePicker.setItems(tempItems)
    // 4
    onTemperatureChanged(0)
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

  @IBAction func onWeightChanged(_ value: Int) {
    ounces = value + 1
  }

  @IBAction func onTemperatureChanged(_ value: Int) {
    let temp = MeatTemperature(rawValue: value)!
    cookTemp = temp
    temperatureLabel.setText(temp.stringValue)
  }
}
