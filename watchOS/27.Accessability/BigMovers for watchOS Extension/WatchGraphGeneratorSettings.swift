
import WatchKit

struct WatchGraphGeneratorSettings: GraphGeneratorSettings {
  
  // elements
  var drawBackgroundGradient: Bool = false
  var drawUnderGraphGradient: Bool = true
  var drawGridlines: Bool = true
  var drawPoints: Bool = true
  
  // colors
  var graphLineColor: UIColor = UIColor.white
  var gridlineMajorColor: UIColor = UIColor.white.withAlphaComponent(0.3)
  var gridlineMinorColor: UIColor = UIColor.white.withAlphaComponent(0.11)
  var underGraphGradientTopColor: CGColor = UIColor.white.withAlphaComponent(0.6).cgColor
  var underGraphGradientBottomColor: CGColor = UIColor.clear.cgColor
  var backgroundGradientTopColor: CGColor = UIColor.orange.cgColor
  var backgroundGradientBottomColor: CGColor = UIColor.red.cgColor
  
  // corners
  var backgroundGradientCornerRadius: Int = 8
  
  // line width
  var gridlineWidth: CGFloat = 1
  var graphLineWidth: CGFloat = 2
  var pointSize: CGFloat = 5
  
  // insets
  var gridlineHorizontalInsets: CGFloat {
    return pointSize / .pi
  }
  var graphHorizontalInsets: CGFloat {
    return pointSize / .pi
  }
  var topInset: CGFloat {
    return pointSize / 2
  }
  var bottomInset:CGFloat {
    return pointSize / 2
  }
  
}
