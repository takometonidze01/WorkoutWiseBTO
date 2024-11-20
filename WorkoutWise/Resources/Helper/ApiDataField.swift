import Foundation

public enum ApiDataField: String, Codable {
  case id = "id"
  case image = "image"
  case name = "name"
  case price = "price"
  case exchange = "exchange"
  case condition = "condition"
  case about = "about"
  case uploadedBy = "uploadedBy"
  case isAd = "isAd"
}

public extension String {
  static subscript(apiDataKey: ApiDataField) -> String {
    return apiDataKey.rawValue
  }
}
