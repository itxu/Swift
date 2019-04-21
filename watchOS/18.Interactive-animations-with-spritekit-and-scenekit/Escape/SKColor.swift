
import SpriteKit

/**
 * Performs a linear interpolation between two SKColor values.
 */

public func lerp(start: SKColor, end: SKColor, t: CGFloat) -> SKColor {
  var r1 = CGFloat(), g1 = CGFloat(), b1 = CGFloat(), a1 = CGFloat() // start color components
  var r2 = CGFloat(), g2 = CGFloat(), b2 = CGFloat(), a2 = CGFloat() // end color components
  
  start.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
  end.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
  
  return SKColor(red: lerp(start: r1, end: r2, t: t),
                 green: lerp(start: g1, end: g2, t: t),
                 blue: lerp(start: b1, end: b2, t: t),
                 alpha: lerp(start: a1, end: a2, t: t))
}
