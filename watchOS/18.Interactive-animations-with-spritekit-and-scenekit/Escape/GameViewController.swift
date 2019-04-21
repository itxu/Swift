
import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
  
  var scene: GameScene!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let view = self.view as! SKView? else {
      return
    }

    scene = GameScene(size: view.frame.size)
    
    // Present the scene
    view.presentScene(scene)
    
    view.ignoresSiblingOrder = true
    
    view.showsFPS = true
    view.showsNodeCount = true
  }
  
  @IBAction func tapRecognized(_ sender: UITapGestureRecognizer) {
    scene.handleTap()
  }
  
  @IBAction func gestureRecognized(_ sender: AnyObject) {
    // 1
    guard let gesture = sender as? UIGestureRecognizer else {
      return
    }
    // 2
    switch gesture.state {
    case .began, .changed:
      let location = gesture.location(in: view)
      // 3
      let y = view.frame.size.height - location.y
      scene.lastTouchPosition = CGPoint(x: location.x, y: y)
    default:
      scene.lastTouchPosition = nil
    }
  }
  
}
