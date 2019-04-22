
import Foundation
import WatchKit

class PlayerInterfaceController: WKInterfaceController {
  
  @IBOutlet private var inlineMovie: WKInterfaceInlineMovie!
  @IBOutlet private var textLabel: WKInterfaceLabel!
  
  private var isPlaying: Bool = true
  private var clipIndex: Int?
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    let index = context as! Int
    
    let provider = VideoClipProvider()
    let clipURL = provider.clips[index]
    let quote = provider.quotes[index]
    
    clipIndex = index
    inlineMovie.setMovieURL(clipURL)
    textLabel.setText(quote)
    setTitle(clipURL.lastPathComponent)
    
    if let data = PosterImageProvider().imageDataForClip(withURL: clipURL) {
      let image = WKImage(imageData: data)
      inlineMovie.setPosterImage(image)
    }
  }
  
  override func willActivate() {
    super.willActivate()
    
    // Handoff.
    guard let clipIndex = clipIndex else { return }
    let userInfo: [AnyHashable: Any] = [
      Handoff.version.key: Handoff.version.number,
      Handoff.activityValueKey: clipIndex
    ]
    updateUserActivity(Handoff.Activity.playClip.stringValue,
                       userInfo: userInfo,
                       webpageURL: nil)
  }
  
  // MARK: Private - methods
  
  @IBAction func onTap(_ sender: AnyObject) {
    if isPlaying {
      inlineMovie.pause()
      isPlaying = false
    } else {
      inlineMovie.play()
      isPlaying = true
    }
  }
}
