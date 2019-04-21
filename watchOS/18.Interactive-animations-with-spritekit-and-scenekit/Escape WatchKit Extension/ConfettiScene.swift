import SceneKit
import SpriteKit

// 1
class ConfettiScene: SCNScene {
  override init() {
    super.init()
    // 2 - Create the particle system
    let particleSystem = SCNParticleSystem()
    particleSystem.birthRate = 50
    particleSystem.emittingDirection = SCNVector3(0, 0, 1)
    particleSystem.spreadingAngle = 60
    particleSystem.particleAngle = 100
    particleSystem.particleAngleVariation = 100
    particleSystem.emitterShape = SCNPlane()
    particleSystem.particleLifeSpan = 7
    particleSystem.particleVelocity = 0.7
    particleSystem.particleVelocityVariation = 0.1
    particleSystem.particleAngularVelocity = 100
    particleSystem.particleAngularVelocityVariation = 100
    particleSystem.acceleration = SCNVector3(0, -0.001, 0)
    particleSystem.speedFactor = 1
    particleSystem.stretchFactor = 0
    particleSystem.particleColor = UIColor.red
    particleSystem.particleColorVariation = SCNVector4(1, 0.1, 0.1, 0)
    particleSystem.particleSize = 0.04
    particleSystem.particleSizeVariation = 0.001
    particleSystem.imageSequenceAnimationMode = .repeat
    particleSystem.blendMode = .alpha
    particleSystem.orientationMode = .free
    particleSystem.sortingMode = .distance
    particleSystem.isAffectedByGravity = true
    particleSystem.isAffectedByPhysicsFields = true
    particleSystem.particleMass = 0.01
    particleSystem.particleBounce = 0.7
    particleSystem.dampingFactor = 0.05
    particleSystem.loops = true
    let translationTransform = SCNMatrix4MakeTranslation(0, 1, 0)
    addParticleSystem(particleSystem, transform: translationTransform)
    // 3 - Create the turbulence field
    let turbulenceField = SCNPhysicsField.turbulenceField(smoothness: 1, animationSpeed: 1)
    turbulenceField.strength = 1.5
    rootNode.physicsField = turbulenceField
    
    let cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    cameraNode.position = SCNVector3(x: 0, y: 0, z: 1.5)
    rootNode.addChildNode(cameraNode)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
