import UIKit
public class CustomCollectionView: UICollectionView {
  private var emptyStateView: (UIView & UIContentView)?

  public init(collectionViewLayout: UICollectionViewLayout) {
    super.init(frame: .zero, collectionViewLayout: collectionViewLayout)
    setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    backgroundColor = .clear
    showsVerticalScrollIndicator = false
    showsHorizontalScrollIndicator = false
    register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.reuseIdentifier)
  }

  deinit {
    print("⬅️🗑 deinit \(String(describing: type(of: self)))")
  }
}

extension UICollectionView {
  func isValid(indexPath: IndexPath) -> Bool {
    guard indexPath.section < numberOfSections, indexPath.row < numberOfItems(inSection: indexPath.section) else {
      return false
    }
    return true
  }
}

public class CustomCollectionViewCell: UICollectionViewCell {
  /// HugeCollectionViewCell reuse identifier
  static let reuseIdentifier = "BetCollectionViewCell"
}
