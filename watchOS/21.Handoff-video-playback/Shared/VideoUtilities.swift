
import AVFoundation
import UIKit

class VideoUtilities {
  
  /// A constant denoting that image size shouldn't be changed.
  /// Use this constant in snapshot(fromMovie:, resizeTo:, completion:) or
  /// in snapshot(fromMovieAtURL:, resizeTo:, completion:) to keep the dimension
  /// of the snapshot image the same as the moive.
  static let OriginalSize = CGSize()
  
  /// Create an snapshot of a movie asset and returns UIImage.
  /// The snapshot process is async and done on a secondary thread.
  /// Completion block is called on the main thread.
  static func snapshot(fromMovie asset: AVAsset, resizeTo newSize: CGSize, completion: @escaping (_ image: UIImage) -> Void) {
    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
      var image = VideoUtilities.snapshotFromMovie(asset: asset)
      
      if !newSize.equalTo(VideoUtilities.OriginalSize) {
        image = VideoUtilities.resize(image: image, toSize: newSize)
      }
      DispatchQueue.main.sync(execute: {
        completion(image)
      })
    }
  }
  
  /// Create an snapshot of a movie at a given URL and returns UIImage.
  /// The snapshot process is async and done on a secondary thread.
  /// Completion block is called on the main thread.
  static func snapshot(fromMovieAtURL URL: URL, resizeTo newSize: CGSize, completion: @escaping (_ image: UIImage) -> Void) {
    let asset = AVAsset(url: URL)
    snapshot(fromMovie: asset, resizeTo: newSize, completion: completion)
  }
  
  /// A prviate method to create an snapshot of a movie and return UIImage.
  private static func snapshotFromMovie(asset: AVAsset) -> UIImage {
    let generator: AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
    generator.appliesPreferredTrackTransform = true
    
    // Make a snapshot of the frame that's halfway through the video.
    let value: Int64 = asset.duration.value / 2
    let scale = asset.duration.timescale
    let time: CMTime = CMTimeMake(value, scale)
    
    let snapshot: UIImage
    do {
      let imageRef: CGImage = try generator.copyCGImage(at: time, actualTime: nil)
      snapshot = UIImage(cgImage: imageRef)
    }
    catch {
      snapshot = UIImage()
    }
    return snapshot
  }
  
  /// Returns a new copy of the input image, resized to the given scale on the x-axis.
  /// Width to height ratio is preserved.
  static func resize(image: UIImage, toSize size: CGSize) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
    let rect  = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
    image.draw(in: rect)
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return resizedImage
  }
  
}
