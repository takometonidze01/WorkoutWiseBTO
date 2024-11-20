import UIKit
public class CustomCollectionViewDataSource<SectionIdentifierType, ItemIdentifierType>: UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> where SectionIdentifierType: ListSectionProvidable, ItemIdentifierType: ListItemProvidable, SectionIdentifierType.ID == ItemIdentifierType.SectionIdentifierType {
  public typealias CellRegistration = CustomCollectionView.CellRegistration<CustomCollectionViewCell, ItemIdentifierType>
  public typealias CellRegistrations = [ListItemType: CellRegistration]

  private var cellRegistrations: CellRegistrations

  public init(
    collectionView view: CustomCollectionView,
    cellRegisrations: CellRegistrations = [:]
  ) {
    self.cellRegistrations = cellRegisrations

    super.init(collectionView: view) { collectionView, indexPath, itemIdentifier in
      guard let cellRegistrationProvider = cellRegisrations[itemIdentifier.type] else {
        fatalError("TNETCollectionViewDataSource cellRegisrtation missing for: \(itemIdentifier.type)")
      }

      return collectionView.dequeueConfiguredReusableCell(
        using: cellRegistrationProvider,
        for: indexPath,
        item: itemIdentifier
      )
    }
  }

  deinit {
    cellRegistrations = [:]
    print("⬅️🗑 deinit TNETCollectionViewDataSource")
  }
}
