import UIKit

public struct TitleContentConfiguration: UIContentConfiguration {

    public let title: String?
    
    public init(title: String? = nil) {
        self.title = title
    }
    
    public func makeContentView() -> UIView & UIContentView {
        TitleContentView(withConfiguration: self)
    }
    
    public func updated(for state: UIConfigurationState) -> TitleContentConfiguration {
        self
    }
}

