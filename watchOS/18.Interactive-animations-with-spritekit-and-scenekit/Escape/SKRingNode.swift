

import SpriteKit

class SKRingNode: SKNode {
  var center: CGPoint
  var diameter: CGFloat
  
  var color = SKColor.white {
    didSet {
      update()
    }
  }
  var thickness: CGFloat = 0.2 {  // decimal percentage of radius, 0...1
    didSet {
      update()
    }
  }
  
  var arcEnd: CGFloat = 0 { // decimal percentage of circumference, usually 0...1
    didSet {
      update()
    }
  }
  
  private var foregroundNode = SKShapeNode()
  private var backgroundNode = SKShapeNode()
  
  init(center: CGPoint, diameter: CGFloat) {
    self.center = center
    self.diameter = diameter
    
    super.init()
    
    foregroundNode.lineCap = .round
    backgroundNode.lineCap = .round
    
    update()
    
    self.addChild(backgroundNode)
    self.addChild(foregroundNode)
  }
  
  required init?(coder decoder: NSCoder) {
    center = CGPoint()
    diameter = 0
    super.init(coder: decoder)
  }
  
  private func update() {
    foregroundNode.strokeColor = color
    backgroundNode.strokeColor = foregroundNode.strokeColor.withAlphaComponent(0.14)
    
    foregroundNode.lineWidth = diameter / 2 * thickness
    backgroundNode.lineWidth = foregroundNode.lineWidth
    
    let radius = diameter / 2 - foregroundNode.lineWidth / 2
    let startAngle = CGFloat.pi / 2
    let endAngle = startAngle - 2 * .pi * (arcEnd + 0.001) // never exactly zero so that the background arc can always be drawn
    
    // The filled part of the ring
    let foregroundPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
    foregroundNode.path = foregroundPath.cgPath
    
    // The empty part of the ring
    let backgroundPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: endAngle, endAngle: startAngle, clockwise: false)
    backgroundNode.path = backgroundPath.cgPath
  }
}

class SKTRingColorEffect: SKTEffect {
  var startColor: SKColor?
  let endColor: SKColor
  
  init(for node: SKRingNode, from startColor: SKColor? = nil, to endColor: SKColor, withDuration duration: TimeInterval) {
    self.startColor = startColor
    self.endColor = endColor
    super.init(node: node, duration: duration)
  }
  
  override func update(_ t: CGFloat) {
    if startColor == nil {
      // purposefully not set until now to get current value during action sequence
      startColor = (node as! SKRingNode).color
    }
    let newColor = lerp(start: startColor!, end: endColor, t: t)
    (node as! SKRingNode).color = newColor
  }
}

class SKTRingValueEffect: SKTEffect {
  var arcStart: CGFloat?
  var arcEnd: CGFloat
  
  init(for node: SKRingNode, from arcStart: CGFloat? = nil, to arcEnd: CGFloat, withDuration duration: TimeInterval) {
    self.arcStart = arcStart
    self.arcEnd = arcEnd
    super.init(node: node, duration: duration)
  }
  
  override func update(_ t: CGFloat) {
    if arcStart == nil {
      // purposefully not set until now to get current value during action sequence
      arcStart = (node as! SKRingNode).arcEnd
    }
    let newArcEnd = lerp(start: arcStart!, end: arcEnd, t: t)
    (node as! SKRingNode).arcEnd = newArcEnd
  }
}
