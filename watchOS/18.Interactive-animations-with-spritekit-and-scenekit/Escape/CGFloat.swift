
import SpriteKit

/**
 * Performs a linear interpolation between two CGFloat values.
 */

func lerp(start: CGFloat, end: CGFloat, t: CGFloat) -> CGFloat {
  return start + (end - start) * t
}
