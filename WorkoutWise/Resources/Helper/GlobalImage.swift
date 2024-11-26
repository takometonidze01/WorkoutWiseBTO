import UIKit

public enum Image: String, CaseIterable, Codable, ImageRepresentable {
    static let assetsLibraryPath = "Images/"
    
    case launchscreen = "launchscreen"
    case pushNotification = "push_notification"
    case unchecked = "uncheck"
    case checked = "check"
    case arrowLeft = "arrow_left"
    case logo = "logo"
    case smallLogo = "small_logo"
    case settingIcon = "setting_icon"
    case gameOver = "game_over"
    case result = "result"
    case home = "home"
    //new
    case close = "close"
    case settings = "settings"
    case plus = "plus"
    case minus = "minus"
    case midIcon = "mid-icon"
    case closeIcon = "close-icon"
    case longIcon = "long-icon"
    case splashIcon = "splash_icon"
    case signIn = "sign-in"
    case calendar = "calendar"
    case repeatIcon = "repeat"
    case appleLogo = "apple.logo"
    
    public func asImage() -> UIImage? {
        return UIImage(image: self)
    }
    
    public func asImage(with tintColor: UIColor?) -> UIImage? {
        guard let tintColor else {
            return UIImage(image: self)
        }
        return UIImage(image: self)?.withTintColor(tintColor)
    }
    
    public func resized(to target: CGSize) -> UIImage? {
        return asImage()?.resized(to: target)
    }
}

public protocol ImageRepresentable {
    func asImage() -> UIImage?
    func asImage(with tintColor: UIColor?) -> UIImage?
}

public extension Image {
    enum System: String, CaseIterable, Codable, ImageRepresentable {
        case close = "xmark"
        case appleLogo = "apple.logo"
        case chevronRight = "chevron.right"
        case chevronDown = "chevron.down"
        case info = "info.circle.fill"
        case ellipsis = "ellipsis"
        case chevronUp = "chevron.up"
        case share = "square.and.arrow.up"
        
        public func asImage() -> UIImage? {
            return UIImage(systemImage: self)
        }
        
        public func asImage(with tintColor: UIColor?) -> UIImage? {
            guard let tintColor else {
                return UIImage(systemImage: self)
            }
            return UIImage(systemImage: self)?.withTintColor(tintColor)
        }
    }
}

public extension UIImage {
    convenience init?(image: Image) {
        self.init(named: "\(Image.assetsLibraryPath)\(image.rawValue)", in: .none, with: nil)
    }
    
    convenience init?(systemImage: Image.System, withConfiguration configuration: UIImage.SymbolConfiguration? = nil) {
        self.init(systemName: systemImage.rawValue, withConfiguration: configuration)
    }
    
    func resized(to target: CGSize) -> UIImage? {
        let ratio = min(target.height / size.height, target.width / size.width)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

