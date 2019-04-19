import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

  @IBOutlet var button: WKInterfaceButton!
  let emoji = EmojiData()

  fileprivate func showFortune() {
    // 1
    let people = emoji.people[emoji.people.count.random()]
    let nature = emoji.nature[emoji.nature.count.random()]
    let objects = emoji.objects[emoji.objects.count.random()]
    let places = emoji.places[emoji.places.count.random()]
    let symbols = emoji.symbols[emoji.symbols.count.random()]
    // 2
    button.setTitle(people + nature + objects + places + symbols)
  }

  @IBAction func newFortune() {
    showFortune()
  }

  override func willActivate() {
    super.willActivate()
    showFortune()
  }

}
