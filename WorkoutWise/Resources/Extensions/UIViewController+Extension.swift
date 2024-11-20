import Foundation
import UIKit

extension UIViewController {
  func dismissKeyboard() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer( target:     self, action:    #selector(UIViewController.dismissKeyboardTouchOutside))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }

  @objc private func dismissKeyboardTouchOutside() {
    view.endEditing(true)
  }
}
