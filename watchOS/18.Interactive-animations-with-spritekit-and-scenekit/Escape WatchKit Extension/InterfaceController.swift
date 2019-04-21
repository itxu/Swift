
import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
  
  @IBOutlet var skInterface: WKInterfaceSKScene!
  var scene: GameScene!
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    scene = GameScene(size: contentFrame.size)
    skInterface.presentScene(scene)
    skInterface.preferredFramesPerSecond = 30
  }
  
  @IBAction func tapRecognized(_ sender: AnyObject) {
    scene.handleTap()
  }
  
  @IBAction func gestureRecognized(_ sender: AnyObject) {
//    // 1
//    guard let gesture = sender as? WKGestureRecognizer else {
//      return
//    }
//    switch gesture.state {
//    case .began, .changed:
//      // 2
//      let location = gesture.locationInObject()
//      // 3
//      let y = contentFrame.size.height - location.y
//      scene.lastTouchPosition = CGPoint(x: location.x, y: y)
//    default:
//      scene.lastTouchPosition = nil
//    }
  }
}
