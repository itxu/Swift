import Foundation

public class Ingredient: Codable {

  public let quantity: String
  public let name: String
  public let type: IngredientType
  public var purchased: Bool?

  init(quantity: String, name: String, type: IngredientType) {
    self.quantity = quantity
    self.name = name
    self.type = type
    self.purchased = false
  }

}

public func ==(lhs: Ingredient, rhs: Ingredient) -> Bool {
  return lhs.quantity == rhs.quantity &&
  lhs.name == rhs.name &&
  lhs.type == rhs.type
}
