
import WatchKit
import Foundation
import WatchConnectivity

class PageInterfaceController: WKInterfaceController, WCSessionDelegate {
  
  @IBOutlet var topGroup: WKInterfaceGroup!
  @IBOutlet var goalLabel: WKInterfaceLabel!
  @IBOutlet var progressGroup: WKInterfaceGroup!
  @IBOutlet var completionsLabel: WKInterfaceLabel!
  @IBOutlet var totalStepsLabel: WKInterfaceLabel!
  @IBOutlet var totalStepsMsgLabel: WKInterfaceLabel!
  @IBOutlet var totalDistanceLabel: WKInterfaceLabel!
  @IBOutlet var totalDistanceUnitLabel: WKInterfaceLabel!
  @IBOutlet var totalDistanceMsgLabel: WKInterfaceLabel!
  @IBOutlet var stepsLabel: WKInterfaceLabel!
  @IBOutlet var distanceLabel: WKInterfaceLabel!
  
  var data: PedometerData!
  var walk: Walk!
  
  let distanceMsgs = ["Ready, set go!",
    "Good progress!",
    "Now you're moving!",
    "You're nearly there!"]
  let stepMsgs = ["It starts with 1 step",
    "They add up fast!",
    "Keep on keeping on...",
    "Give it your all!"]
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    let context = context as! [AnyObject]
    walk = context[0] as! Walk
    setTitle(walk.walkTitle)
    data = context[1] as! PedometerData
  }
  
  override func willActivate() {
    super.willActivate()
    updateInterface()
  }
  
  func formattedString(_ x: CGFloat) -> String {
    return String(format:"%.1f", x)
  }
  
  func updateInterface() {
    topGroup.setBackgroundImage(UIImage(named: walk.imageName))
    stepsLabel.setText("\(data.steps)")
    totalStepsLabel.setText("\(data.totalSteps)")
    
    let goal = CGFloat(walk.goal)
    // distanceUnit-dependant text
    totalDistanceUnitLabel.setText(data.distanceUnit)
    if data.distanceUnit == "km" {
      goalLabel.setText(formattedString(goal) + " km")
      distanceLabel.setText(formattedString(data.distance))
      totalDistanceLabel.setText(formattedString(data.totalDistance))
    } else {
      goalLabel.setText(formattedString(goal.imperial()) + " mi")
      distanceLabel.setText(formattedString(data.distance.imperial()))
      totalDistanceLabel.setText(formattedString(data.totalDistance.imperial()))
    }
    
    // completions
    let completions = data.totalDistance / goal
    completionsLabel.setText(formattedString(completions))
    let fraction = completions.fraction()
    progressGroup.setWidth(fraction * contentFrame.size.width)
    
    // progress bar and messages
    let index = Walk.progressIndex(fraction)
    progressGroup.setBackgroundColor(Walk.progressColors[index])
    totalDistanceMsgLabel.setText(distanceMsgs[index])
    totalStepsMsgLabel.setText(stepMsgs[index])
  }
  
  // WCSessionDelegate method
  
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    
  }
  
}
