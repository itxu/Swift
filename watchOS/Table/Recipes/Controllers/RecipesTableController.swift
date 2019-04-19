import UIKit

class RecipesTableController: UITableViewController {

  var recipeStore = RecipeStore()

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let identifier = segue.identifier

    if identifier == "RecipeDetailSegue" {
      // pass through the selected recipe
      if let path = tableView.indexPathForSelectedRow {
        let recipe = recipeStore.recipes[(path as NSIndexPath).row]
        let destination = segue.destination as! RecipeDetailController
        destination.recipe = recipe
      }
    }
  }

  // MARK: UITableViewDataSource

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return recipeStore.recipes.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
    let recipe = recipeStore.recipes[(indexPath as NSIndexPath).row]
    cell.recipeLabel.text = recipe.name
    if let url = recipe.imageURL {
      cell.thumbnailView.sd_setImage(with: url)
    }
    return cell
  }

}
