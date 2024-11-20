import UIKit

public struct GameRandomItem {
    let id: String
    let index: Int
    let isActive: Bool
}

class GameViewController: UIViewController {
    typealias CollectionViewDataSource = CustomCollectionViewDataSource<ListSectionV2<String>, ListItemV2<String>>
    typealias ListSection = ListSectionV2<String>
    typealias ListItem = ListItemV2<String>
    typealias SnapshotType = NSDiffableDataSourceSnapshot<ListSection, ListItem>
    
    private let presentationAssembly: IPresentationAssembly
    private var dataSource: CollectionViewDataSource?
    private var activeItems: [ListItem] = []
    private var gameItems: [GameRandomItem] = []
    private let userPoint: String

    weak var delegate: MainDelegate?

    private lazy var homeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(image: .home), for: .normal)
        button.tintColor = white
        button.backgroundColor = gray
        button.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var pointWrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = gray
        return view
    }()
    
    private lazy var pointImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(image: .logo))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var pointLabel: UILabel = {
        let label = UILabel()
        label.textColor = white
        label.font = .bold18()
        label.textAlignment = .center
        label.text = "0"
        return label
    }()
    
    private lazy var collectionView: CustomCollectionView = {
        let layout = UICollectionViewCompositionalLayout { [weak self] index, _ -> NSCollectionLayoutSection? in
            guard let self else {
                return nil
            }
            
            return self.getListLayout()
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = CGFloat.spacing9.scaledWidth
        layout.configuration = config
        let view = CustomCollectionView(collectionViewLayout: layout)
        view.backgroundColor = .clear
        //        view.delegate = self
        
        return view
    }()
    
    private lazy var hintLabel: UILabel = {
        let label = UILabel()
        label.textColor = white
        label.font = .bold18()
        label.textAlignment = .center
        label.text = "Choose one of the three boxes!\nTwo are correct one is not.\nPick wisely to continue!"
        label.numberOfLines = 0
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = black
        setup()
        layout(height: 60)
        dataSource = makeDataSource(for: collectionView)
        
        Task.detached(priority: .userInitiated) { [weak self] in
            guard let self else {
                return
            }
            
            await self.updateDataSource()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        homeButton.makeRoundedCorners(.allCorners, withRadius: .cornerRadius2)
        pointWrapperView.makeRoundedCorners(.allCorners, withRadius: .cornerRadius2)
        
        pointLabel.text = userPoint
    }
    
    init(
        userPoint: String,
        delegate: MainDelegate?,
        presentationAssembly: IPresentationAssembly
        
    ) {
        self.userPoint = userPoint
        self.delegate = delegate
        self.presentationAssembly = presentationAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        view.addSubview(collectionView)
        view.addSubview(homeButton)
        view.addSubview(pointWrapperView)
        view.addSubview(hintLabel)
        pointWrapperView.addSubview(pointLabel)
        pointWrapperView.addSubview(pointImageView)
    }
    
    private func layout(height: CGFloat) {
        collectionView.snp.remakeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-CGFloat.spacing7.scaledWidth)
            make.leading.trailing.equalToSuperview().inset(CGFloat.spacing9.scaledWidth)
            make.height.equalTo(height)
        }
        
        homeButton.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat(60.0).scaledWidth)
            make.leading.equalToSuperview().offset(CGFloat.spacing7.scaledWidth)
            make.size.equalTo(CGFloat(44.0).scaledWidth)
        }
        
        hintLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat(144.0).scaledWidth)
            make.centerX.equalToSuperview()
        }
        
        pointWrapperView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat(60.0).scaledWidth)
            make.trailing.equalToSuperview().offset(-CGFloat.spacing7.scaledWidth)
            make.height.equalTo(CGFloat(44.0).scaledWidth)
            make.width.equalTo(CGFloat(100.0).scaledWidth)
        }
        
        pointImageView.snp.remakeConstraints { make in
            make.size.equalTo(CGFloat(18.0).scaledWidth)
            make.leading.equalToSuperview().offset(CGFloat.spacing7.scaledWidth)
            make.centerY.equalToSuperview()
        }
        
        pointLabel.snp.remakeConstraints { make in
            make.leading.equalTo(pointImageView.snp.trailing).offset(CGFloat.spacing8.scaledWidth)
            make.centerY.equalToSuperview()
        }
    }
    
    private func makeDataSource(for collectionView: CustomCollectionView) -> CollectionViewDataSource? {
        let cellRegistrations: CollectionViewDataSource.CellRegistrations = [
            .activeButtons: getActiveButtonsCell(),
            .inactiveButtons: getInactiveButtonsCell()
        ]
        
        dataSource = CollectionViewDataSource(collectionView: collectionView, cellRegisrations: cellRegistrations)
        return dataSource
    }
    
    private func getActiveButtonsCell() -> CollectionViewDataSource.CellRegistration {
        CollectionViewDataSource.CellRegistration { [weak self] cell, _, identifier in
            guard let self else {
                return
            }

            let configuration = ActiveButtonsContentConfiguration { [weak self] index, isActive in
                guard let self else { return }
                hintLabel.isHidden = true
                hintLabel.isUserInteractionEnabled = false
                // Create a new active item and add it to activeItems
                let newActiveItem = ListItem(id: UUID().uuidString, sectionIdentifier: ProfileSceneSectionID.inactive.rawValue, type: .inactiveButtons)
                self.activeItems.append(newActiveItem) // Add to active items
                
                let gameNewItem = GameRandomItem(id: UUID().uuidString, index: index, isActive: isActive)
                gameItems.append(gameNewItem)
                
                Task.detached(priority: .userInitiated) { [weak self] in
                    guard let self else { return }
                    await self.updateDataSource { [weak self] in
                        guard let self else { return }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: { [weak self] in
                            guard let self else { return }

                            self.gameResult(isActive: isActive)
                        })
                    } // Refresh the data source
                }
            }
            cell.contentConfiguration = configuration
        }
    }
    
    private func gameResult(isActive: Bool) {
        if !isActive {
//            let vc = presentationAssembly.resultViewController(winner: false, userPoint: userPoint, resultString: "Game over\nTry again?", delegate: self)
//            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        if gameItems.count == 10 && isActive {
//            let vc = presentationAssembly.resultViewController(winner: true, userPoint: userPoint, resultString: "You won!\n+5 points", delegate: self)
//            self.navigationController?.pushViewController(vc, animated: false)
        }
    }

    
    private func updateInactiveItems() {
        // Update the inactive items based on the number of active items
        let newInactiveItems = activeItems.map { _ in
            ListItem(id: UUID().uuidString, sectionIdentifier: ProfileSceneSectionID.inactive.rawValue, type: .inactiveButtons)
        }
        
        // Clear previous inactive items and add the new ones
        activeItems = newInactiveItems
    }
    
    private func getInactiveButtonsCell() -> CollectionViewDataSource.CellRegistration {
        CollectionViewDataSource.CellRegistration { [weak self] cell, indexPath, identifier in
            guard let self else { return }
            
            guard let item = gameItems.first(where: { $0.id == identifier.id }) else {
              return
            }
            print(item)
            let configuration = InactiveContentConfiguration(gameRandomItem: item)
            cell.contentConfiguration = configuration
        }
    }
    
    @MainActor
    private func updateDataSource(completion: (() -> Void)? = nil) {
        var snapshot = SnapshotType()

        // Create and append active section
        let activeListSection = ListSection(id: ProfileSceneSectionID.active.rawValue, title: "")
        snapshot.appendSections([activeListSection])

        // Active item
        let activeListItems: [ListItem] = [
            ListItem(id: UUID().uuidString, sectionIdentifier: activeListSection.id, type: .activeButtons)
        ]
        snapshot.appendItems(activeListItems, toSection: activeListSection)
        
        for (index, _) in activeItems.indices.enumerated() {
            let inactiveListSection = ListSection(id: "\(ProfileSceneSectionID.inactive.rawValue)\(index)", title: "")
            snapshot.appendSections([inactiveListSection])
            
            let inactiveListItem = ListItem(id: gameItems[index].id, sectionIdentifier: inactiveListSection.id, type: .inactiveButtons)
            snapshot.appendItems([inactiveListItem], toSection: inactiveListSection)
        }

        dataSource?.apply(snapshot, animatingDifferences: true, completion: completion)

        layout(height: CGFloat(60 + (activeItems.count * 68)))
    }

    
    
    private func getListLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(60)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitem: item, count: 1)
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [verticalGroup, verticalGroup])
        horizontalGroup.interItemSpacing = .fixed(16.0)
        
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.interGroupSpacing = 4.0
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
        return section
    }
    
    @objc func homeButtonTapped() {
        delegate?.resetDashboard()
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension GameViewController: MainDelegate {
    func resetDashboard() {
        delegate?.resetDashboard()
    }
}
