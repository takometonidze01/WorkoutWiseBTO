//
//  WorkoutData.swift
//  Skull
//
//  Created by Tako Metonidze on 11/14/24.
//

import Foundation

public struct WorkoutData: Codable {
    let id: String
    let time: Int
    let closeRange: Int
    let midRangeHits: Int
    let longRangeHits: Int
    let hitCount: Int
    let total: Int
    let createdAt: String
    let userId: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case time
        case closeRange = "close_range"
        case midRangeHits = "mid_range_hits"
        case longRangeHits = "long_range_hits"
        case hitCount = "hitCount"
        case total
        case createdAt = "created_at"
        case userId = "user_id"
    }
}

public struct WorkoutParams {
    var time: Int
    var closeRange: Int
    var midRangeHits: Int
    var longRangeHits: Int
    var hitCount: Int
    var total: Int
    var userId: String
    
    public init(
        time: Int,
        closeRange: Int,
        midRangeHits: Int,
        longRangeHits: Int,
        hitCount: Int,
        total: Int,
        userId: String
    ) {
        self.time = time
        self.closeRange = closeRange
        self.midRangeHits = midRangeHits
        self.longRangeHits = longRangeHits
        self.hitCount = hitCount
        self.total = total
        self.userId = userId
    }
    
    public static func initial(
      appleToken: String = "",
      pushToken: String = ""
    )  -> Self {
        .init(time: 0, closeRange: 0, midRangeHits: 0, longRangeHits: 0, hitCount: 0, total: 0, userId: "")
      }

    var asServiceParams: [String: Any] {
        var params: [String: Any] = [:]
        
        params["time"] = time
        params["close_range"] = closeRange
        params["mid_range_hits"] = midRangeHits
        params["long_range_hits"] = longRangeHits
        params["hitCount"] = hitCount
        params["total"] = total
        params["user_id"] = userId

        return params
    }
}
