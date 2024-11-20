import UIKit

public struct HistoryContentConfiguration: UIContentConfiguration {
    public typealias DidTapOnViewFull = (() -> Void)

    public let workoutData: WorkoutData?
    public let didTapOnViewFullButton: DidTapOnViewFull?
    
    public init(workoutData: WorkoutData? = nil, didTapOnViewFullButton: DidTapOnViewFull? = nil) {
        self.workoutData = workoutData
        self.didTapOnViewFullButton = didTapOnViewFullButton
    }
    
    public func makeContentView() -> UIView & UIContentView {
        HistoryContentView(withConfiguration: self)
    }
    
    public func updated(for state: UIConfigurationState) -> HistoryContentConfiguration {
        self
    }
}

