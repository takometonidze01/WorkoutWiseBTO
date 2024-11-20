import UIKit
import ProgressHUD

class MainDashboardViewController: UIViewController {
    typealias CollectionViewDataSource = CustomCollectionViewDataSource<ListSectionV2<String>, ListItemV2<String>>
    typealias ListSection = ListSectionV2<String>
    typealias ListItem = ListItemV2<String>
    typealias SnapshotType = NSDiffableDataSourceSnapshot<ListSection, ListItem>

    private let presentationAssembly: IPresentationAssembly
    private var dataSource: CollectionViewDataSource?
    
    private var workoutStats: WorkoutData?
    private var historyData: [WorkoutData] = []

    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(image: .settings), for: .normal)
        button.tintColor = white
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var primaryButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(white, for: .normal)
        button.backgroundColor = red
        button.setImage(UIImage(image: .plus), for: .normal)
        button.addTarget(self, action: #selector(primaryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: CustomCollectionView = {
      let layout = UICollectionViewCompositionalLayout { [weak self] index, _ -> NSCollectionLayoutSection? in
        guard let self else {
          return nil
        }

        if index == 0 {
            return self.getStatisticLayout()
        }

        if index == 1 {
          return self.getTitleLayout()
        }

          return self.historyLayout()
      }

      let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = CGFloat.spacing5.scaledWidth
      layout.configuration = config
        let view = CustomCollectionView(collectionViewLayout: layout)
      view.backgroundColor = .clear
//      view.delegate = self

      return view
    }()


    init(
        presentationAssembly: IPresentationAssembly
    ) {
        self.presentationAssembly = presentationAssembly
        super.init(nibName: nil, bundle: nil)
        
        getWorkoutStatistics()
        getHistory()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = black
        setup()
        layout()
        
        dataSource = makeDataSource(for: collectionView)

//        collectionView.contentInset = .init(top: 0, left: 0, bottom: 120, right: 0)
        Task.detached(priority: .userInitiated) { [weak self] in
          guard let self else {
            return
          }

          await self.updateDataSource()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        primaryButton.makeRoundedCorners(.allCorners, withRadius: 60.0 / 2)
        settingsButton.makeRoundedCorners(.allCorners, withRadius: .cornerRadius2)
    }

    
    private func showAlert(title: String, description: String?, okHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            okHandler?()
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setup() {
        view.addSubview(settingsButton)
        view.addSubview(collectionView)
        view.addSubview(primaryButton)
    }
    
    private func layout() {
        settingsButton.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat(60.0).scaledWidth)
            make.trailing.equalToSuperview().offset(-CGFloat.spacing7.scaledWidth)
            make.size.equalTo(CGFloat(24.0).scaledWidth)
        }
        
        primaryButton.snp.remakeConstraints { make in
            make.size.equalTo(CGFloat(60.0).scaledWidth)
            make.trailing.equalToSuperview().offset(-CGFloat.spacing7.scaledWidth)
            make.bottom.equalToSuperview().offset(-CGFloat.spacing3.scaledWidth)
        }
        
        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(settingsButton.snp.bottom).offset(CGFloat.spacing1.scaledWidth)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func makeDataSource(for collectionView: CustomCollectionView) -> CollectionViewDataSource? {
      let cellRegistrations: CollectionViewDataSource.CellRegistrations = [
        .statistics: getStatisticCell(),
        .history: getHistoryCell(),
        .titleWrapper: getTitleCell()
      ]

      dataSource = CollectionViewDataSource(collectionView: collectionView, cellRegisrations: cellRegistrations)
      return dataSource
    }
    
    private func getStatisticCell() -> CollectionViewDataSource.CellRegistration {
      CollectionViewDataSource.CellRegistration { [weak self] cell, _, identifier in
        guard let self else {
          return
        }

          let configuration = StatisticContentConfiguration(statistics: workoutStats)
        cell.contentConfiguration = configuration
      }
    }
    
    private func getHistoryCell() -> CollectionViewDataSource.CellRegistration {
      CollectionViewDataSource.CellRegistration { [weak self] cell, _, identifier in
        guard let self else {
          return
        }
          guard let data = historyData.first(where: { $0.id == identifier.id }) else { return }
          let configuration = HistoryContentConfiguration(workoutData: data) { [weak self] in
              guard let self else { return }

              let vc = presentationAssembly.resultViewController(workout: data, delegate: nil)
              self.navigationController?.pushViewController(vc, animated: false)
          }
        cell.contentConfiguration = configuration
      }
    }
    
    private func getTitleCell() -> CollectionViewDataSource.CellRegistration {
      CollectionViewDataSource.CellRegistration { [weak self] cell, _, identifier in
        guard let self else {
          return
        }

          let configuration = TitleContentConfiguration(title: "History")
        cell.contentConfiguration = configuration
      }
    }
    
    @MainActor
    private func updateDataSource() {
      var snapshot = SnapshotType()

      let contactListSection: ListSection = ListSection(id: "statistic-section", title: "")

      var listItems: [ListItem] = []

      snapshot.appendSections([contactListSection])
        listItems = [ListItem(id: UUID().uuidString, sectionIdentifier: contactListSection.id, type: .statistics)]

      snapshot.appendItems(listItems, toSection: contactListSection)

      let otherSettings: ListSection = ListSection(id: "history-title-section", title: "")

      var otherListItems: [ListItem] = []

        if !historyData.isEmpty {
            snapshot.appendSections([otherSettings])
            otherListItems = [ListItem(id: UUID().uuidString, sectionIdentifier: otherSettings.id, type: .titleWrapper)]
            snapshot.appendItems(otherListItems, toSection: otherSettings)
        }



      let activeAdsSection: ListSection = ListSection(id: "history-section", title: "")

      var activeAdsListItem: [ListItem] = []
        if !historyData.isEmpty {
            snapshot.appendSections([activeAdsSection])
            activeAdsListItem = historyData.map({
                ListItem(id: $0.id, sectionIdentifier: activeAdsSection.id, type: .history)
            })
            
            
            snapshot.appendItems(activeAdsListItem, toSection: activeAdsSection)
        }

      dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    @objc func settingsButtonTapped() {
        let vc = presentationAssembly.profileScene(userPoint: "0")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func primaryButtonTapped() {
        let vc = presentationAssembly.chooseTimeScene(delegate: self)
      if let sheet = vc.sheetPresentationController {
        sheet.detents = [.medium()]
        sheet.preferredCornerRadius = 16
      }
      present(vc, animated: true, completion: nil)
    }
    
    private func getWorkoutStatistics() {
        let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        
        NetworkManager.shared.get(url: "https://online-trainer-16e523bc14c8.herokuapp.com/api/v1/workouts/statistics/\(userId)", parameters: nil, headers: nil) { (result: Result<WorkoutData>) in
            switch result {
            case .success(let exercises):
                DispatchQueue.main.async {
                    ProgressView.shared.showProgressHud(animate: false)
//                    let totalTime = exercises.map(\.time).reduce(0, +)
                    let timeInString = convertSecondsToTimeString(Double(exercises.time))
//                    self.timerLabel.text = timeInString
    
                    
                }
                self.workoutStats = exercises
                self.updateDataSource()
            case .failure(let error):
                print("Error: \(error)")
                DispatchQueue.main.async {
                    ProgressView.shared.showProgressHud(animate: false)
                }
            }
        }
    }
    
    private func getHistory() {
        let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        
        NetworkManager.shared.get(url: "https://online-trainer-16e523bc14c8.herokuapp.com/api/v1/workouts/?user_id=\(userId)", parameters: nil, headers: nil) { (result: Result<[WorkoutData]>) in
            switch result {
            case .success(let historyData):
                DispatchQueue.main.async {
                    ProgressView.shared.showProgressHud(animate: false)
                    
                }
                self.historyData = historyData
                self.updateDataSource()
            case .failure(let error):
                print("Error: \(error)")
                DispatchQueue.main.async {
                    ProgressView.shared.showProgressHud(animate: false)
                }
            }
        }
    }
    
    private func getStatisticLayout() -> NSCollectionLayoutSection {
      let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .absolute(423.0)
      )

      let item = NSCollectionLayoutItem(layoutSize: itemSize)

      let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitem: item, count: 1)

      let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [verticalGroup, verticalGroup])
      horizontalGroup.interItemSpacing = .fixed(16.0)

      let section = NSCollectionLayoutSection(group: horizontalGroup)
      section.interGroupSpacing = 16.0
      section.contentInsets = NSDirectionalEdgeInsets(
        top: CGFloat.spacing6.scaledWidth,
        leading: 0,
        bottom: 0,
        trailing: 0
      )

      return section
    }
    
    private func getTitleLayout() -> NSCollectionLayoutSection {
      let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .absolute(30)
      )

      let item = NSCollectionLayoutItem(layoutSize: itemSize)

      let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitem: item, count: 1)

      let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [verticalGroup, verticalGroup])
      horizontalGroup.interItemSpacing = .fixed(16.0)

      let section = NSCollectionLayoutSection(group: horizontalGroup)
      section.interGroupSpacing = 16.0
      section.contentInsets = NSDirectionalEdgeInsets(
        top: 10,
        leading: 0,
        bottom: 0,
        trailing: 0
      )

      return section
    }
    
    private func historyLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(170)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: verticalGroup)
        section.interGroupSpacing = 8.0
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
        return section
    }
}

extension MainDashboardViewController: MainDelegate {
    func resetDashboard() {
        workoutStats = nil
        historyData = []
        
        getHistory()
        getWorkoutStatistics()
    }
}

extension MainDashboardViewController: ChooseTimeDelegate {
    func didChooseTime(_ time: String) {
        let vc = presentationAssembly.workoutScene(time: time, delegate: self)
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
