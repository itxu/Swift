
import Foundation

class PosterImageProvider {
  
  /// Returns image data for a given clip URL. If image data doesn't exist
  /// yet, it returns nil.
  func imageDataForClip(withURL url: URL) -> Data? {
    let name = url.lastPathComponent
    let fileManager = FileManager.default
    let userDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last!
    let posterImageURL = userDocuments.appendingPathComponent(name)
    let data = try? Data(contentsOf: posterImageURL)
    return data
  }
}
