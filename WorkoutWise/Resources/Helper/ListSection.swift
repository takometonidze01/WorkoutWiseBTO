import Foundation
public protocol ListSectionProvidable: Hashable, Identifiable {
}

public struct ListSectionV2<T: Hashable>: ListSectionProvidable {
  public enum SectionType: Equatable {
    case regular
    case paginationActivityIndicator
  }

  public let id: T
  public let title: String
  public let type: SectionType

  public init(id: T, title: String, type: SectionType = .regular ) {
    self.id = id
    self.title = title
    self.type = type
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
    hasher.combine(self.title)
    hasher.combine(self.type)
  }

  public static func == (lhs: ListSectionV2, rhs: ListSectionV2) -> Bool {
    return lhs.id.hashValue == rhs.id.hashValue && lhs.title == rhs.title && lhs.type == rhs.type
  }
}

public struct ListItemV2<SectionIdentifierType: Hashable>: ListItemProvidable {
  public typealias SectionIdentifierType = SectionIdentifierType

  public let id: String
  public let sectionIdentifier: SectionIdentifierType
  public let type: ListItemType

  public init(id: String, sectionIdentifier: SectionIdentifierType, type: ListItemType) {
    self.id = id
    self.sectionIdentifier = sectionIdentifier
    self.type = type
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id.hashValue)
    hasher.combine(sectionIdentifier.hashValue)
    hasher.combine(type.hashValue)
  }

  public static func == (lhs: ListItemV2, rhs: ListItemV2) -> Bool {
    return lhs.sectionIdentifier.hashValue == rhs.sectionIdentifier.hashValue
    && lhs.type == rhs.type
    && lhs.id == rhs.id
  }
}

public protocol ListItemProvidable: Hashable, Identifiable {
  associatedtype SectionIdentifierType: Hashable

  var type: ListItemType { get }

  init(id: String, sectionIdentifier: SectionIdentifierType, type: ListItemType)
}
