import UIKit

class StatisticContentView: UIView, UIContentView {
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your statistics"
        label.font = .medium16()
        label.textColor = white
        return label
    }()
    
    private lazy var trainingTimeWrapperView: ResultWrapperView = {
        let view = ResultWrapperView()
        view.setTitleAndDescription(title: "Total time spent on Workouts", description: "00:10:00")
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


    init(withConfiguration conf: StatisticContentConfiguration) {
        configuration = conf
        super.init(frame: .zero)
        setup()
        configure(configuration: conf)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
    }
    
    private func setup() {
        addSubview(titleLabel)
        addSubview(trainingTimeWrapperView)
        addSubview(threeHorizontalStackView)
        addSubview(twoHorizontalStackView)
    }
    
    private func configure(configuration: UIContentConfiguration) {
        guard let config = configuration as? StatisticContentConfiguration else {
            return
        }
        
        guard let workoutData = config.statistics else {
            return
        }
        
        closeRangeHitsWrapperView.setTitleAndDescription(title: "Close range hits", description: "\(workoutData.closeRange)")
        midRangeHitsWrapperView.setTitleAndDescription(title: "Mid range hits", description: "\(workoutData.midRangeHits)")
        longRangeHitsWrapperView.setTitleAndDescription(title: "Long range hits", description: "\(workoutData.longRangeHits)")
        totalHitsWrapperView.setTitleAndDescription(title: "Total hits", description: "\(workoutData.hitCount)")
        missesWrapperView.setTitleAndDescription(title: "Misses", description: "\(workoutData.total)")
        trainingTimeWrapperView.setTitleAndDescription(title: "Total time spent on Workouts", description: "\(secondsToTime(seconds: workoutData.time))")
        
        layout()
    }
    
    func secondsToTime(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secondsLeft = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, secondsLeft)
    }

    private func layout() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview()
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
}
