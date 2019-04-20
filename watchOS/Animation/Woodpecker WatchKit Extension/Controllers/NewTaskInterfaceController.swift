
import WatchKit

class NewTaskInterfaceController: WKInterfaceController {
  static let ControllerName = "NewTaskInterfaceController"
  @IBOutlet var addNameButton: WKInterfaceButton!
  @IBOutlet var addNameGroup: WKInterfaceGroup!
  
  @IBOutlet var timesLabel: WKInterfaceLabel!
  @IBOutlet var timesSelectedLabel: WKInterfaceLabel!
  @IBOutlet var timesSlider: WKInterfaceSlider!
  
  @IBOutlet var colorLabel: WKInterfaceLabel!
  @IBOutlet var blueButton: WKInterfaceButton!
  @IBOutlet var purpleButton: WKInterfaceButton!
  @IBOutlet var greenButton: WKInterfaceButton!
  @IBOutlet var orangeButton: WKInterfaceButton!
  @IBOutlet var yellowButton: WKInterfaceButton!
  @IBOutlet var redButton: WKInterfaceButton!
  
  @IBOutlet var bottomGroup: WKInterfaceGroup!
  @IBOutlet var createButton: WKInterfaceButton!
  @IBOutlet var cancelButton: WKInterfaceButton!
  
  @IBOutlet var errorImage: WKInterfaceImage!
  
  func colorButtons() -> [WKInterfaceButton] {
    return [blueButton, purpleButton, greenButton, orangeButton, redButton, yellowButton]
  }
  
  var selectedColorButton: WKInterfaceButton?
  var selectedColor: Task.Color?
  var name: String?
  var times: Int = 20
  
  var tasks: TaskList!
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    tasks = context as! TaskList
    setUpColorButtons()
    
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }

  override func didAppear() {
    super.didAppear()
    animateInColorButtons()
  }

  func animateInColorButtons() {
    // 1
    let timeStep = Int64(0.1 * Double(NSEC_PER_SEC))
    // 2
    for (i, button) in colorButtons().enumerated() {
      // 3
      let delayTime = DispatchTime.now() +
        Double(timeStep * Int64(i)) / Double(NSEC_PER_SEC)
      DispatchQueue.main.asyncAfter(deadline: delayTime) {
        // 4
        self.animate(withDuration:0.4) {
          if button === self.selectedColorButton {
            button.setAlpha(1)
          } else {
            button.setAlpha(0.3)
          }
        }
      }
    }
  }
}

// MARK: Actions
extension NewTaskInterfaceController {
  @IBAction func addName() {
    let options = ["Work Out", "Express Love", "Drink Water", "Skip Dessert"]
    presentTextInputController(withSuggestions: options, allowedInputMode: WKTextInputMode.plain) { results in
      if let result = results?.first as? String {
        self.addNameButton.setTitle(result)
        self.name = result
      }
    }
  }
  
  @IBAction func onSliderChange(_ value: Float) {
    times = Int(value)
    timesSelectedLabel.setText("\(times)")
  }
  
  @IBAction func onCreate() {
    guard let name = name, let color = selectedColor else {
      displayError()
      return
    }
    let task = Task(name: name, color: color, totalTimes: times)
    tasks.addTask(task)
    dismiss()
  }
  
  @IBAction func onCancel() {
    dismiss()
  }
}

// MARK: Error Handling
extension NewTaskInterfaceController {
  func displayError() {
    errorImage.setHidden(false)
    // 1
    errorImage.setImageNamed("x")

    // 2
    errorImage.startAnimating()
    animate(withDuration:0.4) {
      self.errorImage.sizeToFitHeight()
    }

    let delayTime = DispatchTime.now() +
      Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
      self.animate(withDuration:0.4) {
        self.errorImage.setHeight(0)
      }
    }
  }
}

// MARK: Color Selection
extension NewTaskInterfaceController {
  func setUpColorButtons() {
    blueButton.setBackgroundColor(Task.Color.blue.color)
    purpleButton.setBackgroundColor(Task.Color.purple.color)
    greenButton.setBackgroundColor(Task.Color.green.color)
    orangeButton.setBackgroundColor(Task.Color.orange.color)
    yellowButton.setBackgroundColor(Task.Color.yellow.color)
    redButton.setBackgroundColor(Task.Color.red.color)
  }
  
  func selectColor(_ color: Task.Color, button: WKInterfaceButton) {
    selectedColor = color

    animate(withDuration:0.4) {
      if let previous = self.selectedColorButton {
        previous.setAlpha(0.3)
      }
      self.selectedColorButton = button
      button.setAlpha(1)
      self.addNameGroup.setBackgroundColor(
        color.color.withAlphaComponent(0.3))
    }
  }
  
  @IBAction func onBlue() {
    selectColor(Task.Color.blue, button: blueButton)
  }
  @IBAction func onPurple() {
    selectColor(Task.Color.purple, button: purpleButton)
  }
  @IBAction func onGreen() {
    selectColor(Task.Color.green, button: greenButton)
  }
  @IBAction func onOrange() {
    selectColor(Task.Color.orange, button: orangeButton)
  }
  @IBAction func onYellow() {
    selectColor(Task.Color.yellow, button: yellowButton)
  }
  @IBAction func onRed() {
    selectColor(Task.Color.red, button: redButton)
  }
}
