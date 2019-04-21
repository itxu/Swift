import Foundation

private let kRecipesFileName = "Recipes"
private let kRecipesFileExtension = "json"

public class RecipeStore {

  public lazy var recipes: [Recipe] = {
    var recipes = [Recipe]()
	if let data = try? Data(contentsOf: self.savedRecipesURL) {
		
		if let decoded = try? JSONDecoder().decode([Recipe].self, from: data) {
			print("Sucessfully decoded, Valid JSON provided")
			recipes = decoded
		} else {
			print("Unable to decode, JSON is invalid")
		}
	}
	return recipes
}()

  // MARK: Private

  private let savedRecipesURL: URL = {
    return Bundle(for: RecipeStore.self).url(forResource: kRecipesFileName, withExtension: kRecipesFileExtension)!
    }()

}
