import UIKit
protocol MainDelegate: AnyObject {
    func resetDashboard()
}

class ResultViewController: UIViewController {
    private let presentationAssembly: IPresentationAssembly
    
    weak var delegate: MainDelegate?
    private var workoutData: WorkoutData

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Training results"
        label.font = .medium16()
        label.textColor = white
        return label
    }()
    
    private lazy var trainingTimeWrapperView: ResultWrapperView = {
        let view = ResultWrapperView()
        view.setTitleAndDescription(title: "Training time", description: "00:10:00")
        return view
    }()
    
    private lazy var closeRangeHitsWrapperView: ResultWrapperView = {
        let view = ResultWrapperView()
        view.setTitleAndDescription(title: "Close range hits", description: "0")
        return view
    }()
    
    private lazy var midRangeHitsWrapperView: ResultWrapperView = {
        let view = ResultWrapperView()
        view.setTitleAndDescription(title: "Mid range hits", description: "0")
        return view
    }()
    
    private lazy var longRangeHitsWrapperView: ResultWrapperView = {
        let view = ResultWrapperView()
        view.setTitleAndDescription(title: "Long range hits", description: "0")
        return view
    }()
    
    private lazy var totalHitsWrapperView: ResultWrapperView = {
        let view = ResultWrapperView()
        view.setTitleAndDescription(title: "Total hits", description: "0")
        return view
    }()
    
    private lazy var missesWrapperView: ResultWrapperView = {
        let view = ResultWrapperView()
        view.setTitleAndDescription(title: "Misses", description: "0")
        return view
    }()
    
    private lazy var threeHorizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ closeRangeHitsWrapperView, midRangeHitsWrapperView, longRangeHitsWrapperView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var twoHorizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ totalHitsWrapperView, missesWrapperView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()

    private lazy var primaryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .medium14()
        button.setTitleColor(white, for: .normal)
        button.backgroundColor = red
        button.addTarget(self, action: #selector(didTapOnPrimaryButton), for: .touchUpInside)
        return button
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
        
        closeRangeHitsWrapperView.setTitleAndDescription(title: "Close range hits", description: "\(workoutData.closeRange)")
        midRangeHitsWrapperView.setTitleAndDescription(title: "Mid range hits", description: "\(workoutData.midRangeHits)")
        longRangeHitsWrapperView.setTitleAndDescription(title: "Long range hits", description: "\(workoutData.longRangeHits)")
        totalHitsWrapperView.setTitleAndDescription(title: "Total hits", description: "\(workoutData.hitCount)")
        missesWrapperView.setTitleAndDescription(title: "Misses", description: "\(workoutData.total)")
        trainingTimeWrapperView.setTitleAndDescription(title: "Training time", description: "\(secondsToTime(seconds: workoutData.time))")
    }
    
    init(
        workoutData: WorkoutData,
        delegate: MainDelegate?,
        presentationAssembly: IPresentationAssembly
    ) {
        self.workoutData = workoutData
        self.delegate = delegate
        self.presentationAssembly = presentationAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        primaryButton.makeRoundedCorners(.allCorners, withRadius: .cornerRadius2)
    }
    
    func secondsToTime(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secondsLeft = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, secondsLeft)
    }
    
    private func setup() {
        view.addSubview(titleLabel)
        view.addSubview(trainingTimeWrapperView)
        view.addSubview(threeHorizontalStackView)
        view.addSubview(twoHorizontalStackView)
        view.addSubview(primaryButton)
    }
    
    private func layout() {
        primaryButton.snp.remakeConstraints { make in
            make.bottom.equalToSuperview().offset(-CGFloat(48.0).scaledWidth)
            make.centerX.equalToSuperview()
            make.height.equalTo(CGFloat(40.0).scaledWidth)
            make.width.equalTo(CGFloat(170.0).scaledWidth)
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat(211.0).scaledWidth)
            make.leading.equalToSuperview().offset(CGFloat.spacing7.scaledWidth)
        }
        
        trainingTimeWrapperView.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(CGFloat(20.0).scaledWidth)
            make.leading.trailing.equalToSuperview().inset(CGFloat.spacing7.scaledWidth)
            make.height.equalTo(CGFloat(116.0).scaledWidth)
        }
        
        threeHorizontalStackView.snp.remakeConstraints { make in
            make.top.equalTo(trainingTimeWrapperView.snp.bottom).offset(CGFloat(10.0).scaledWidth)
            make.leading.trailing.equalToSuperview().inset(CGFloat.spacing7.scaledWidth)
            make.height.equalTo(CGFloat(131.0).scaledWidth)
        }
        
        twoHorizontalStackView.snp.remakeConstraints { make in
            make.top.equalTo(threeHorizontalStackView.snp.bottom).offset(CGFloat(10.0).scaledWidth)
            make.leading.trailing.equalToSuperview().inset(CGFloat.spacing7.scaledWidth)
            make.height.equalTo(CGFloat(116.0).scaledWidth)
        }
        
    }
    
    @objc func didTapOnPrimaryButton() {
        delegate?.resetDashboard()
        self.navigationController?.popToRootViewController(animated: true)
    }
}
