import UIKit

class ViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
  
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var weightPicker: UIPickerView!
  @IBOutlet weak var tempLabel: UILabel!
  @IBOutlet weak var tempSlider: UISlider!
  @IBOutlet weak var timerButton: UIButton!
  
  var startTime: TimeInterval = 0
  var timer: Timer?
  var cookTime: TimeInterval = 0
  
  var currentCookTemp: MeatTemperature {
    return MeatTemperature(rawValue: Int(tempSlider.value))!
  }
  
  var currentOunces: Int {
    return weightPicker.selectedRow(inComponent: 0) + 1
  }
  
  @IBAction func onTempChanged(_ sender: AnyObject) {
    tempLabel.text = currentCookTemp.stringValue
  }
  
  @IBAction func onStartButton(_ sender: AnyObject) {
    cookTime = currentCookTemp.cookTimeForOunces(currentOunces)
    
    if let timer = timer, timer.isValid {
      stopTimer()
    } else {
      startTimer()
    }
  }
  
  func startTimer() {
    timerButton.setTitle("Stop Timer", for: UIControlState())
    
    startTime = floor(CACurrentMediaTime())
    timerDidFire(self)
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerDidFire(_:)), userInfo: nil, repeats: true)
  }
  
  func stopTimer() {
    timerButton.setTitle("Start Timer", for: UIControlState())
    
    timer?.invalidate()
  }
  
  @objc func timerDidFire(_ sender: AnyObject) {
    let diff = floor(CACurrentMediaTime() - startTime)
    let time = cookTime - diff
    let hour = time / (60.0 * 60.0)
    let fHour = floor(hour)
    let minute = (time - fHour * 60.0 * 60.0) / 60.0
    let fMinute = floor(minute)
    let second = time - fHour * 60.0 * 60.0 - fMinute * 60.0
    
    var text = ""
    if fHour > 0 {
      text += NSString(format: "%.0Fh ", fHour) as String
    }
    if fMinute > 0 {
      text += NSString(format: "%.0Fm ", fMinute) as String
    }
    text += NSString(format: "%.0Fs", second) as String
    
    timeLabel.text = text
  }
  
  //MARK: UIPickerViewDataSource
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return 32
  }
  
  //MARK: UIPickerViewDelegate
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return "\(row + 1)"
  }
  
}

