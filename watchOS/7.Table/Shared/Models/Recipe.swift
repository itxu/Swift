import Foundation

public class Recipe : Codable {

  public let name: String
  public let type: String
  public let ingredients: [Ingredient]
  public let steps: [String]
  public let timers: [Int]
  public let imageURL: URL?
  public let originalURL: URL?

  public init(
    name: String,
    type: String,
    ingredients: [Ingredient],
    steps: [String],
    timers: [Int],
    imageURL: URL?,
    originalURL: URL?
    ) {
    self.name = name
    self.type = type
    self.ingredients = ingredients
    self.steps = steps
    self.timers = timers
    self.imageURL = imageURL
    self.originalURL = originalURL
  }

}
