//
//  UserParams.swift
//  X Sportsmarket
//
//  Created by Tako Metonidze on 11/1/24.
//

import Foundation

public struct UserParams {
    var appleToken: String
    var pushToken: String?
    
    public init(
      appleToken: String,
      pushToken: String? = nil
    ) {
        self.appleToken = appleToken
        self.pushToken = pushToken
    }
    
    public static func initial(
      appleToken: String = "",
      pushToken: String = ""
    )  -> Self {
        .init(appleToken: "", pushToken: "")
      }

    var asServiceParams: [String: Any] {
        var params: [String: Any] = [:]
        
        params["auth_token"] = appleToken
        params["push_token"] = pushToken

        return params
    }
}

public struct UserInfo: Codable {
    let appleToken: String
    let pushToken: String
    let id: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case appleToken = "auth_token"
        case pushToken = "push_token"
        case id
        case createdAt = "created_at"
    }
}

public struct DeleteUserResponse: Codable {
    let message: String
}
