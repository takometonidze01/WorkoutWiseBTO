import UIKit

public struct ActiveButtonsContentConfiguration: UIContentConfiguration {
    public typealias DidTapOnActiveButton = ((Int, Bool) -> Void)

    public let title: String?
    public let didTapOnActiveButton: DidTapOnActiveButton?
    
    public init(title: String? = nil, didTapOnActiveButton: DidTapOnActiveButton? = nil) {
        self.title = title
        self.didTapOnActiveButton = didTapOnActiveButton
    }
    
    public func makeContentView() -> UIView & UIContentView {
        ActiveButtonContentView(withConfiguration: self)
    }
    
    public func updated(for state: UIConfigurationState) -> ActiveButtonsContentConfiguration {
        self
    }
}

