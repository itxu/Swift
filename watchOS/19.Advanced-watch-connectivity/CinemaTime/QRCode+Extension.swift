
import Foundation
import UIKit

extension QRCode {
  public var PNGData: Data {
    let context = CIContext(options: nil)
    let cgImage = context.createCGImage(self.ciImage, from: self.ciImage.extent)
    let image = UIImage(cgImage: cgImage!)
    let data = UIImagePNGRepresentation(image)!
    return data
  }
}
