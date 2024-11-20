import UIKit

class Constraints {
    
    static let deviceHeight = UIScreen.main.bounds.height
    static let deviceWidth = UIScreen.main.bounds.width
    
    /// width ratio compared to iPhone 13 pro max with width = 428
    static var xCoeff: CGFloat {
        return deviceWidth / 390.0
    }

    /// height ratio compared to iPhone 13 pro max with height = 926
    static var yCoeff: CGFloat {
        return deviceHeight / 844.0
    }

}

public struct Constants {
    public struct Screen {
        static let factor = UIScreen.main.bounds.width / 390.0
        static let heightFactor = UIScreen.main.bounds.height / 844.0
        static let height = UIScreen.main.bounds.height
        static let width = UIScreen.main.bounds.width
    }
}

public extension CGFloat {
    
    var scaledWidth: CGFloat {
        return (self * Constants.Screen.factor).rounded(.toNearestOrAwayFromZero)
    }
    
    var scaledHeight: CGFloat {
        return self * Constants.Screen.heightFactor
    }

}
