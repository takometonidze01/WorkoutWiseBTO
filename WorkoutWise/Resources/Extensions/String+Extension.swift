import UIKit

extension String {
  var underLined: NSAttributedString {
    NSMutableAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
  }

  func toAttributed(alignment: NSTextAlignment) -> NSAttributedString {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    return toAttributed(attributes: [.paragraphStyle: paragraphStyle])
  }

  func toAttributed(attributes: [NSAttributedString.Key : Any]? = nil) -> NSAttributedString {
    return NSAttributedString(string: self, attributes: attributes)
  }
}
