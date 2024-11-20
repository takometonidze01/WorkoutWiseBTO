import UIKit

extension UITableViewCell {
  static var identifier: String {
    return String(describing: self)
  }

  static func nib() -> UINib {
    return UINib(nibName: identifier, bundle: nil)
  }
}
