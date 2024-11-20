import Foundation

public struct UserPoint: Codable {
    public var currentCoins: Int
    public var lastUpdated: String
    
    enum CodingKeys: String, CodingKey {
        case currentCoins = "current_coins"
        case lastUpdated = "last_updated"
    }
}

public struct UserPointUpdate: Codable {
    public var message: String
    public var coins: Int
}
