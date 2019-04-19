import UIKit

enum RecipeDetailSelection: Int {
  case ingredients = 0, steps
}

class RecipeDetailController: UIViewController {

  var recipe: Recipe?
  var initialController: RecipeDetailSelection = .ingredients
  
  @IBOutlet weak var segmentedControl: UISegmentedControl!

  lazy var ingredientsController: RecipeIngredientsController! = {
    let controller = self.storyboard?.instantiateViewController(withIdentifier: "RecipeIngredientsController") as? RecipeIngredientsController
    controller?.recipe = self.recipe
    controller?.tableView.contentInset = self.tableInsets
    return controller
  }()

  lazy var stepsController: RecipeDirectionsController! = {
    let controller = self.storyboard?.instantiateViewController(withIdentifier: "RecipeDirectionsController") as? RecipeDirectionsController
    controller?.recipe = self.recipe
    controller?.tableView.contentInset = self.tableInsets
    return controller
  }()

  // don't rely on automaticallyAdjustsScrollViewInsets since we're swapping child controllers
  var tableInsets: UIEdgeInsets {
    var insets = UIEdgeInsets.zero
    if let nav = navigationController {
      insets.top = nav.navigationBar.bounds.height
      insets.top += 20 // status bar
    }
    if let tab = tabBarController {
      insets.bottom = tab.tabBar.bounds.height
    }
    return insets
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    segmentedControl.selectedSegmentIndex = initialController.rawValue
    updateSelectedController(initialController)
  }

  @IBAction func onSegmentChange(_ sender: UISegmentedControl) {
    if let index = RecipeDetailSelection(rawValue: sender.selectedSegmentIndex) {
      updateSelectedController(index)
    } else {
      print("Unsupported recipe detail selection \(sender.selectedSegmentIndex)")
      abort()
    }
  }

  func updateSelectedController(_ selected: RecipeDetailSelection) {
    switch selected {
    case .ingredients:
      addSubViewController(ingredientsController)
      stepsController.removeFromSuperViewController()
      break
    case .steps:
      addSubViewController(stepsController)
      ingredientsController.removeFromSuperViewController()
      break
    }
  }

}
