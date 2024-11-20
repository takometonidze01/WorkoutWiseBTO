import UIKit

public struct InactiveContentConfiguration: UIContentConfiguration {
    public let gameRandomItem: GameRandomItem?
    
    public init(gameRandomItem: GameRandomItem? = nil) {
        self.gameRandomItem = gameRandomItem
    }
    
    public func makeContentView() -> UIView & UIContentView {
        InactiveContentView(withConfiguration: self)
    }
    
    public func updated(for state: UIConfigurationState) -> InactiveContentConfiguration {
        self
    }
}

