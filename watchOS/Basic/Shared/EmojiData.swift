import Foundation

extension Int {
  func random() -> Int {
    return Int(arc4random_uniform(UInt32(self)))
  }
}

struct EmojiData {
  let people = ["😄", "😙", "😔", "😣", "😕", "👯", "💁"]
  let nature = ["🐣", "🍀", "🌺", "🌴", "⛅️", "🐋", "🐺"]
  let objects = ["🎁", "⏳", "🍎", "🎵", "💰", "⌚️"]
  let places = ["✈️", "♨️", "🎭", "🚲", "🎢"]
  let symbols = ["🔁", "🔀", "⏩", "⏪", "🆒"]
}
