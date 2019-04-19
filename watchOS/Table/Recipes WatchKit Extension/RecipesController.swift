import Foundation
import WatchKit

class RecipesController: WKInterfaceController {

  @IBOutlet var table: WKInterfaceTable!

  let recipeStore = RecipeStore()
  var map = [String: [Recipe]]()

  override func awake(withContext context: Any?) {
    super.awake(withContext: context)

    // 1
    for recipe in recipeStore.recipes {
      var arr = map[recipe.type] ?? [Recipe]()
      arr.append(recipe)
      map[recipe.type] = arr
    }

    // 2
    for (type, recipes) in map {
      add(withType: type, recipes: recipes)
    }
  }

  func add(withType type: String, recipes: [Recipe]) {
    // 1
    let rows = table.numberOfRows

    // 2
    table.insertRows(at: NSIndexSet(index: rows) as IndexSet, withRowType: "HeaderRowType")

    // 3
    let itemRows = NSIndexSet(indexesIn: NSRange(location: rows + 1, length: recipes.count))
    table.insertRows(at: itemRows as IndexSet, withRowType: "RecipeRowType")

    for i in rows..<table.numberOfRows {
      // 1
      let controller = table.rowController(at: i)

      // 2
      if let controller = controller as? HeaderRowController {
        controller.image.setImageNamed(type.lowercased())
        controller.label.setText(type)
        // 3
      } else if let controller = controller as? RecipeRowController {
        let recipe = recipes[i - rows - 1]
        controller.titleLabel.setText(recipe.name)
        controller.ingredientsLabel.setText("\(recipe.ingredients.count) ingredients")
      }
    }
  }

  override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
    var originalIndex = rowIndex
    for (_, recipes) in map {
      originalIndex-=1
      if originalIndex < recipes.count {
        return recipes[originalIndex]
      }
      originalIndex -= recipes.count
    }
    return nil
  }
}
