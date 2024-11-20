import UIKit

extension UIColor {
  convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
    var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format
    
    if (cString.hasPrefix("#")) {
      cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) == 6) {
      Scanner(string: cString).scanHexInt32(&rgbValue)
    }
    
    self.init(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: alpha
    )
  }
}


class GradientLabel: UILabel {
  var gradientColors: [CGColor] = []
  
  override func drawText(in rect: CGRect) {
    if let gradientColor = drawGradientColor(in: rect, colors: gradientColors) {
      self.textColor = gradientColor
    }
    super.drawText(in: rect)
  }
  
  private func drawGradientColor(in rect: CGRect, colors: [CGColor]) -> UIColor? {
    let currentContext = UIGraphicsGetCurrentContext()
    currentContext?.saveGState()
    defer { currentContext?.restoreGState() }
    
    let size = rect.size
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                    colors: colors as CFArray,
                                    locations: nil) else { return nil }
    
    let context = UIGraphicsGetCurrentContext()
    context?.drawLinearGradient(gradient,
                                start: CGPoint.zero,
                                end: CGPoint(x: 0, y: size.height),
                                options: [])
    let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    guard let image = gradientImage else { return nil }
    return UIColor(patternImage: image)
  }
}
