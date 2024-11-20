import Foundation
import UIKit

extension UIFont {
    static func semiBold32() -> UIFont {
      return UIFont(name: "Montserrat-SemiBold", size: 32) ?? .systemFont(ofSize: 14)
    }

    static func semiBold16() -> UIFont {
      return UIFont(name: "Montserrat-SemiBold", size: 16) ?? .systemFont(ofSize: 14)
    }
    
    static func semiBold14() -> UIFont {
      return UIFont(name: "Montserrat-SemiBold", size: 14) ?? .systemFont(ofSize: 14)
    }

    static func regular18() -> UIFont {
      return UIFont(name: "Montserrat-Regular", size: 18) ?? .boldSystemFont(ofSize: 10)
    }
    
    static func bold18() -> UIFont {
      return UIFont(name: "Montserrat-Bold", size: 18) ?? .boldSystemFont(ofSize: 10)
    }
    
    static func bold24() -> UIFont {
      return UIFont(name: "Montserrat-Bold", size: 24) ?? .boldSystemFont(ofSize: 10)
    }
    
    static func medium12() -> UIFont {
      return UIFont(name: "Montserrat-Medium", size: 12) ?? .boldSystemFont(ofSize: 10)
    }
    
    static func medium14() -> UIFont {
      return UIFont(name: "Montserrat-Medium", size: 14) ?? .boldSystemFont(ofSize: 10)
    }
    
    static func medium16() -> UIFont {
      return UIFont(name: "Montserrat-Medium", size: 16) ?? .boldSystemFont(ofSize: 10)
    }
    
    static func medium24() -> UIFont {
      return UIFont(name: "Montserrat-Medium", size: 24) ?? .boldSystemFont(ofSize: 10)
    }
}
