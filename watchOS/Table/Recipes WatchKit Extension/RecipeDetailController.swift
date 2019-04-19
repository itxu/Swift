import WatchKit
import Foundation

class RecipeDetailController: WKInterfaceController {

  @IBOutlet var table: WKInterfaceTable!

  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    // 1
    if let recipe = context as? Recipe {
      // 1
      let rowTypes: [String] =
        ["RecipeHeader"] + recipe.steps.map({ _ in "RecipeStep" })
      table.setRowTypes(rowTypes)
      for i in 0..<table.numberOfRows {
        let row = table.rowController(at: i)
        if let header = row as? RecipeHeaderController {
          header.titleLabel.setText(recipe.name)
          // 2
        } else if let step = row as? RecipeStepController {
          step.stepLabel.setText("\(i). " + recipe.steps[i - 1])
        }
      }
    }
  }
}
