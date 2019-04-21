import UIKit

class RecipeDirectionsController: UITableViewController {

  var recipe: Recipe!

  // MARK: Actions

  func promptToStartTimerForStepIndex(_ stepIndex: Int) {
    let alert = UIAlertController(title: "Start a Timer", message: "Would you like to start a timer for \(recipe.timers[stepIndex]) minutes?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Start Timer", style: .default, handler: { _ in
      self.startTimerForStepIndex(stepIndex)
    }))
    present(alert, animated: true, completion: nil)
  }

  func startTimerForStepIndex(_ stepIndex: Int) {

    let userInfo: [String : Any] = [
      "category" : "timer",
      "timer" : recipe.timers[stepIndex],
      "message" : "Timer: \(recipe.steps[stepIndex])",
      "title" : recipe.name
    ]
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.scheduleTimerNotificationWithUserInfo(userInfo)
  }

  // MARK: UITableViewDataSource

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return recipe.steps.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeStepsCell", for: indexPath)
    let step = recipe.steps[(indexPath as NSIndexPath).row]
    cell.textLabel?.text = "\((indexPath as NSIndexPath).row+1). \(step)"
    return cell
  }

  // MARK: UITableViewDelegate

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if recipe.timers[(indexPath as NSIndexPath).row] > 0 {
      promptToStartTimerForStepIndex((indexPath as NSIndexPath).row)
    }
  }
}
