import UIKit

public struct StatisticContentConfiguration: UIContentConfiguration {

    public let statistics: WorkoutData?
    
    public init(statistics: WorkoutData?) {
        self.statistics = statistics
    }
    
    public func makeContentView() -> UIView & UIContentView {
        StatisticContentView(withConfiguration: self)
    }
    
    public func updated(for state: UIConfigurationState) -> StatisticContentConfiguration {
        self
    }
}

