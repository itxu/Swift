
import UIKit

struct CardGraphGeneratorSettings: GraphGeneratorSettings {
  
  // elements
  var drawBackgroundGradient: Bool = true
  var drawUnderGraphGradient: Bool = true
  var drawGridlines: Bool = true
  var drawPoints: Bool = true
  
  // colors
  var graphLineColor: UIColor = UIColor.white
  var gridlineMajorColor: UIColor = UIColor.white.withAlphaComponent(0.3)
  var gridlineMinorColor: UIColor = UIColor.white.withAlphaComponent(0.11)
  var underGraphGradientTopColor: CGColor = UIColor.white.withAlphaComponent(0.6).cgColor
  var underGraphGradientBottomColor: CGColor = UIColor.clear.cgColor
  var backgroundGradientTopColor: CGColor = UIColor.black.cgColor
  var backgroundGradientBottomColor: CGColor = UIColor.black.cgColor
  
  // corners
  var backgroundGradientCornerRadius: Int = 0
  
  // line width
  var gridlineWidth: CGFloat = 1
  var graphLineWidth: CGFloat = 2
  var pointSize: CGFloat = 5
  
  // insets
  var gridlineHorizontalInsets: CGFloat = 15
  var graphHorizontalInsets: CGFloat = 65
  var topInset: CGFloat = 60
  var bottomInset:CGFloat = 20
  
}
