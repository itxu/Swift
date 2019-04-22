
import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
  
  let clipProvider = VideoClipProvider()
  let posterImageProvider = PosterImageProvider()
  
  // MARK: Properties
  
  @IBOutlet private var table: WKInterfaceTable!
  
  // MARK: Life Cycle
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    initializeTable()
  }
  
  override func willActivate() {
    super.willActivate()
    updateTable()
    
    // Handoff.
    let userInfo: [AnyHashable: Any] = [
      Handoff.version.key: Handoff.version.number,
      Handoff.activityValueKey: ""
    ]
    updateUserActivity(Handoff.Activity.viewHome.stringValue,
                       userInfo: userInfo,
                       webpageURL: nil)
  }
  
  override func didDeactivate() {
    super.didDeactivate()
  }
  
  override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
    return rowIndex
  }
  
  // MARK: Private - methods
  
  private func initializeTable() {
    let count = clipProvider.clips.count
    table.setNumberOfRows(count, withRowType: VideoRowController.IBIdentifier)
  }
  
  func updateTable() {
    let clips = clipProvider.clips
    for (index, clip) in clips.enumerated() {
      let rowController = table.rowController(at: index) as! VideoRowController
      let imageData = posterImageProvider.imageDataForClip(withURL: clip)
      let hasImageData = (imageData != nil)
      rowController.image.setImageData(imageData)
      rowController.image.setHidden(!hasImageData)
      rowController.textLabel.setText("Loading...")
      rowController.textLabel.setHidden(hasImageData)
    }
  }
}
