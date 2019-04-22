
import Foundation

class VideoClipProvider {
  
  /// For convenience and share common code. This is the key in a message request
  /// sent by the watch app to the phone, requesting poster image. The value to
  /// this key is from clipReferences dictionary that maps to a video clip.
  static let WCPosterImageRequestKey = "WCPosterImageRequestKey"
  
  /// An array of URL to video assets in the app bundle.
  let clips: [URL]
  
  let quotes: [String] = [
    "Whoever said you can't buy happiness forgot little puppies.",
    "Buy a pup and your money will buy love unflinching.",
    "A puppy plays with every pup he meets",
    "People have been asking me if I was going to have kids, and I had puppies instead.",
    "When you feel lousy, puppy therapy is indicated.",
    "The only creatures that are evolved enough to convey pure love are dogs and infants."
  ]
  
  /// A dictionary representation of video assets. Keys are name of
  /// video clips as String, and values are URL pointing to assets
  /// in the app bundle.
  let clipReferences: [String: URL]
  
  init () {
    
    /// Video clips in the bundle are named sequentially.
    /// To make the code more generic, here you refactor the minimum
    /// and maximum index so that assets can be loaded in a loop.
    let minIndex = 1
    let maxIndex = 3
    
    // Initialize array of clips.
    var files: [URL] = []
    for index in stride(from: minIndex, through: maxIndex, by: 1) {
      let file = Bundle.main.url(forResource: "clip\(index)", withExtension: "mp4")!
      files.append(file)
    }
    clips = files
    
    // Initialize the reference map.
    var references: [String: URL] = [:]
    for clip in clips {
      references[clip.lastPathComponent] = clip
    }
    clipReferences = references
  }
  
}
