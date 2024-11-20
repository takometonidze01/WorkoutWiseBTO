import Foundation
import UIKit

public enum CornerRadiusType {
  case fixed(corners: CACornerMask, value: CGFloat)
  case circle
  case pill
  case none
}

extension UIView {
  var safeTopAnchor: NSLayoutYAxisAnchor {
    if #available(iOS 11.0, *) {
      return self.safeAreaLayoutGuide.topAnchor
    }
    return self.topAnchor
  }

  var safeLeftAnchor: NSLayoutXAxisAnchor {
    if #available(iOS 11.0, *){
      return self.safeAreaLayoutGuide.leftAnchor
    }
    return self.leftAnchor
  }

  var safeRightAnchor: NSLayoutXAxisAnchor {
    if #available(iOS 11.0, *){
      return self.safeAreaLayoutGuide.rightAnchor
    }
    return self.rightAnchor
  }

  var safeBottomAnchor: NSLayoutYAxisAnchor {
    if #available(iOS 11.0, *) {
      return self.safeAreaLayoutGuide.bottomAnchor
    }
    return self.bottomAnchor
  }

  func shake() {
    let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
    animation.duration = 0.6
    animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
    layer.add(animation, forKey: "shake")
  }

  func dropShadow() {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.white.cgColor
    layer.shadowOpacity = 0.3
    layer.shadowOffset = CGSize(width: -1, height: 1)
    layer.shadowRadius = 3
  }

  func apply(cornerRadius: CornerRadiusType) {
    switch cornerRadius {
    case .fixed(let corners, let value):
      makeRoundedCorners(corners, withRadius: value)
    case .circle:
      makeRoundedCorners(.allCorners, withRadius: bounds.size.width / 2.0)
    case .pill:
      makePillCorners()
    case .none:
      clipsToBounds = false
      layer.cornerRadius = 0
      layer.maskedCorners = []
    }
  }

  func makeRoundedCorners(_ corners: CACornerMask, withRadius radius: CGFloat = 8.0, clipsToBounds: Bool = true) {
    self.clipsToBounds = clipsToBounds
    layer.cornerRadius = radius
    layer.maskedCorners = corners
  }

  func makePillCorners() {
    let radius = bounds.size.height > bounds.size.width
    ? bounds.size.width / 2.0
    : bounds.size.height / 2.0
    makeRoundedCorners(.allCorners, withRadius: radius)
  }

  func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
    let border = UIView()
    border.backgroundColor = color
    border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
    border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
    addSubview(border)
  }

  func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
    let border = UIView()
    border.backgroundColor = color
    border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
    border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
    addSubview(border)
  }

  func addLeftBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
    let border = UIView()
    border.backgroundColor = color
    border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
    border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.size.height)
    addSubview(border)
  }

  func addBottomBorderWithPadding(width: CGFloat, borderWidth: CGFloat = 1, color: UIColor, padding: CGFloat) {
    let borderLayer = CALayer()
    borderLayer.backgroundColor = color.resolvedColor(with: traitCollection).cgColor
    borderLayer.frame = CGRect(x: padding, y: bounds.height - width, width: bounds.width - 2 * padding, height: width)
    layer.addSublayer(borderLayer)
  }

  func addTopDashedBorder(
    with color: UIColor?,
    andWidth borderWidth: CGFloat,
    dashLength: CGFloat,
    betweenDashesSpace: CGFloat
  ) {
    let shapeLayer: CAShapeLayer = CAShapeLayer()
    let frameSize = self.frame.size
    let shapeRect = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)

    shapeLayer.bounds = shapeRect
    shapeLayer.position = CGPoint(x: frameSize.width / 2, y: 0)
    shapeLayer.fillColor = UIColor.clear.resolvedColor(with: traitCollection).cgColor
    shapeLayer.strokeColor = color?.resolvedColor(with: traitCollection).cgColor
    shapeLayer.lineWidth = borderWidth
    shapeLayer.lineJoin = CAShapeLayerLineJoin.miter
    shapeLayer.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
    shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 0).cgPath

    self.layer.addSublayer(shapeLayer)
  }

  func addBottomDashedBorder(
    with color: UIColor?,
    andWidth borderWidth: CGFloat,
    dashLength: CGFloat,
    betweenDashesSpace: CGFloat
  ) {
    let shapeLayer: CAShapeLayer = CAShapeLayer()
    let frameSize = self.frame.size
    let shapeRect = CGRect(x: 0, y: frameSize.height - borderWidth, width: frameSize.width, height: borderWidth)

    shapeLayer.bounds = shapeRect
    shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height)
    shapeLayer.fillColor = UIColor.clear.resolvedColor(with: traitCollection).cgColor
    shapeLayer.strokeColor = color?.resolvedColor(with: traitCollection).cgColor
    shapeLayer.lineWidth = borderWidth
    shapeLayer.lineJoin = CAShapeLayerLineJoin.miter
    shapeLayer.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
    shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 0).cgPath

    self.layer.addSublayer(shapeLayer)
  }
}


extension UIViewController {
  func displayMsg(title: String?,
                  msg: String,
                  style: UIAlertController.Style = .alert,
                  dontRemindKey: String? = nil,
                  completionHandler: (()->())? = nil) {

    if dontRemindKey != nil,
       UserDefaults.standard.bool(forKey: dontRemindKey!) == true {
      return
    }

    let ac = UIAlertController.init(title: title,
                                    message: msg, preferredStyle: style)

    ac.addAction(UIAlertAction.init(title: "OK",
                                    style: .default,
                                    handler: {_ in completionHandler?()}))

    if dontRemindKey != nil {
      ac.addAction(UIAlertAction.init(title: "Don't Remind",
                                      style: .default, handler: { (_) in
        UserDefaults.standard.set(true, forKey: dontRemindKey!)
        UserDefaults.standard.synchronize()
      }))
    }

    DispatchQueue.main.async {
      ac.show()
    }
  }

  func displayMsgWithoutActions(
    title: String?,
    msg: String
  ) {

    let ac = UIAlertController.init(title: title,
                                    message: msg, preferredStyle: .alert)
    DispatchQueue.main.async {
      ac.show()
    }
  }
}

extension UIAlertController {

  func show(animated: Bool = true, completion: (() -> Void)? = nil) {
    if let visibleViewController = UIApplication.shared.keyWindow?.visibleViewController {
      visibleViewController.present(self, animated: animated, completion: completion)
    }
  }
}

extension UIWindow {
  var visibleViewController: UIViewController? {
    guard let rootViewController = rootViewController else {
      return nil
    }
    return visibleViewController(for: rootViewController)
  }

  private func visibleViewController(for controller: UIViewController) -> UIViewController {
    var nextOnStackViewController: UIViewController? = nil
    if let presented = controller.presentedViewController {
      nextOnStackViewController = presented
    } else if let navigationController = controller as? UINavigationController,
              let visible = navigationController.visibleViewController {
      nextOnStackViewController = visible
    } else if let tabBarController = controller as? UITabBarController,
              let visible = (tabBarController.selectedViewController ??
                             tabBarController.presentedViewController) {
      nextOnStackViewController = visible
    }

    if let nextOnStackViewController = nextOnStackViewController {
      return visibleViewController(for: nextOnStackViewController)
    } else {
      return controller
    }
  }
}

public extension CACornerMask {
  static var allCorners: Self = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
  static var onlyRightCorners: Self = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
  static var onlyLeftCorners: Self = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
  static var onlyTopCorners: Self = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
  static var onlyBottomCorners: Self = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
}
