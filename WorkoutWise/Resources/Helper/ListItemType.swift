import Foundation
public enum ListItemType: String, Hashable, CaseIterable {
    case activeButtons
    case inactiveButtons
    case otherSettings
    
    //new
    case statistics
    case history
    case titleWrapper
}
