import UIKit

class WorkoutViewController: UIViewController {
    private let presentationAssembly: IPresentationAssembly
    private var isCloseActive: Bool = false
    private var isMidActive: Bool = false
    private var isLongActive: Bool = true
    
    private var time: String
    private var closeRangeHits = 0
    private var midRangeHits = 0
    private var longRangeHits = 0
    private var misses = 0
    private var totalHits: Int { closeRangeHits + midRangeHits + longRangeHits }
    
    private var timer: Timer?
    private var timeInSeconds: Int = 0
    private var timeOfWorkout: Int = 0
    private var isTimerRunning = false

    private var workoutParams: WorkoutParams = .initial()

    weak var delegate: MainDelegate?

    private lazy var wrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = black
        return view
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(image: .close), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(image: .longIcon)
        return imageView
    }()
    
    private lazy var bottomWrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = gray
        return view
    }()
    
    private lazy var timeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Time"
        label.textColor = .white
        label.font = .semiBold16()
        return label
    }()
    
    private lazy var timeWrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = black
        return view
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.font = .medium14()
        label.textColor = white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var distanceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Distance"
        label.textColor = .white
        label.font = .semiBold16()
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(white, for: .normal)
        button.backgroundColor = black
        button.titleLabel?.font = .medium14()
        button.addTarget(self, action: #selector(didTapOnClose), for: .touchUpInside)
        return button
    }()
    
    private lazy var midButton: UIButton = {
        let button = UIButton()
        button.setTitle("Mid", for: .normal)
        button.setTitleColor(white, for: .normal)
        button.backgroundColor = black
        button.titleLabel?.font = .medium14()
        button.addTarget(self, action: #selector(didTapOnMid), for: .touchUpInside)
        return button
    }()
    
    private lazy var longButton: UIButton = {
        let button = UIButton()
        button.setTitle("Long", for: .normal)
        button.setTitleColor(white, for: .normal)
        button.backgroundColor = red
        button.titleLabel?.font = .medium14()
        button.addTarget(self, action: #selector(didTapOnLong), for: .touchUpInside)
        return button
    }()
    
    private lazy var missButton: UIButton = {
        let button = UIButton()
        button.setTitle("Miss", for: .normal)
        button.setTitleColor(white, for: .normal)
        button.setTitleColor(gray, for: .highlighted)
        button.backgroundColor = black
        button.titleLabel?.font = .medium14()
        button.addTarget(self, action: #selector(didTapOnMiss), for: .touchUpInside)
        return button
    }()
    
    private lazy var hitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Hit", for: .normal)
        button.setTitleColor(white, for: .normal)
        button.setTitleColor(gray, for: .highlighted)
        button.backgroundColor = black
        button.titleLabel?.font = .medium14()
        button.addTarget(self, action: #selector(didTapOnHit), for: .touchUpInside)
        return button
    }()
    
    private lazy var threeButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [closeButton, midButton, longButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var twoButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [missButton, hitButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var alertView: AlertView = {
        let view = AlertView(title: "Are you sure you want to complete\nthe workout?", description: "If you finish a workout before, the data about it will be saved without the ability to edit and will be displayed in your statistics", cancelButtonTitle: "Cancel", deleteButtonTitle: "Yes")
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        
        startTimer()
    }
    
    init(
        time: String,
        delegate: MainDelegate?,
        presentationAssembly: IPresentationAssembly
    ) {
        self.time = time
        self.delegate = delegate
        self.presentationAssembly = presentationAssembly
        super.init(nibName: nil, bundle: nil)
        
        timeLabel.text = time
        timeInSeconds = WorkoutViewController.timeToSeconds(time: time)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        wrapperView.makeRoundedCorners(.onlyTopCorners, withRadius: .cornerRadius2)
        timeWrapperView.makeRoundedCorners(.allCorners, withRadius: .cornerRadius2)
        closeButton.makeRoundedCorners(.allCorners, withRadius: .cornerRadius2)
        midButton.makeRoundedCorners(.allCorners, withRadius: .cornerRadius2)
        longButton.makeRoundedCorners(.allCorners, withRadius: .cornerRadius2)
        missButton.makeRoundedCorners(.allCorners, withRadius: .cornerRadius2)
        hitButton.makeRoundedCorners(.allCorners, withRadius: .cornerRadius2)
        bottomWrapperView.makeRoundedCorners(.allCorners, withRadius: .cornerRadius2)
    }
    
    private func setup() {
        view.addSubview(wrapperView)
        
        wrapperView.addSubview(dismissButton)
        wrapperView.addSubview(imageView)
        wrapperView.addSubview(bottomWrapperView)
        
        bottomWrapperView.addSubview(timeTitleLabel)
        bottomWrapperView.addSubview(timeWrapperView)
        bottomWrapperView.addSubview(distanceTitleLabel)
        timeWrapperView.addSubview(timeLabel)
        bottomWrapperView.addSubview(threeButtonStackView)
        bottomWrapperView.addSubview(twoButtonStackView)
        
        view.addSubview(alertView)
    }
    
    private func layout() {
        wrapperView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        alertView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dismissButton.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat(70.0).scaledWidth)
            make.leading.equalToSuperview().offset(CGFloat.spacing7.scaledWidth)
            make.size.equalTo(CGFloat(24.0).scaledWidth)
        }
        
        imageView.snp.remakeConstraints { make in
            make.top.equalTo(dismissButton.snp.bottom).offset(CGFloat(44.0).scaledWidth)
            make.leading.trailing.equalToSuperview().inset(CGFloat.spacing7.scaledWidth)
            make.height.equalTo(CGFloat(372.0).scaledWidth)
        }
        
        bottomWrapperView.snp.remakeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(CGFloat(20.0).scaledWidth)
            make.leading.trailing.equalToSuperview().inset(CGFloat.spacing7.scaledWidth)
            make.bottom.equalToSuperview().offset(-CGFloat.spacing6.scaledWidth)
        }
        
        timeTitleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat.spacing7.scaledWidth)
            make.leading.equalToSuperview().offset(CGFloat(20.0).scaledWidth)
        }
        
        timeWrapperView.snp.remakeConstraints { make in
            make.top.equalTo(timeTitleLabel.snp.bottom).offset(CGFloat(10).scaledWidth)
            make.leading.trailing.equalToSuperview().inset(CGFloat(20.0).scaledWidth)
            make.height.equalTo(CGFloat(40.0).scaledWidth)
        }
        
        timeLabel.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        distanceTitleLabel.snp.remakeConstraints { make in
            make.top.equalTo(timeWrapperView.snp.bottom).offset(CGFloat(10).scaledWidth)
            make.leading.equalToSuperview().offset(CGFloat(20.0).scaledWidth)
        }
        
        threeButtonStackView.snp.remakeConstraints { make in
            make.top.equalTo(distanceTitleLabel.snp.bottom).offset(CGFloat(10).scaledWidth)
            make.leading.trailing.equalToSuperview().inset(CGFloat(20.0).scaledWidth)
            make.height.equalTo(CGFloat(40.0).scaledWidth)
        }
        
        twoButtonStackView.snp.remakeConstraints { make in
            make.top.equalTo(threeButtonStackView.snp.bottom).offset(CGFloat(10).scaledWidth)
            make.leading.trailing.equalToSuperview().inset(CGFloat(20.0).scaledWidth)
            make.height.equalTo(CGFloat(100.0).scaledWidth)
        }
    }
    
    private func changeActiveButton() {
        if isCloseActive {
            closeButton.backgroundColor = red
            midButton.backgroundColor = black
            longButton.backgroundColor = black
            imageView.image = UIImage(image: .closeIcon)
        }
        
        if isMidActive {
            closeButton.backgroundColor = black
            midButton.backgroundColor = red
            longButton.backgroundColor = black
            imageView.image = UIImage(image: .midIcon)
        }
        
        if isLongActive {
            closeButton.backgroundColor = black
            midButton.backgroundColor = black
            longButton.backgroundColor = red
            imageView.image = UIImage(image: .longIcon)
        }
    }
    

    
    private func handleAlertTap() {
        alertView.isHidden = false
        
        alertView.didTapOnCancelButton = { [weak self] in
            guard let self else { return }
            self.alertView.isHidden = true
            self.startTimer()
        }
        
        alertView.didTapOnDeleteButton = { [weak self] in
            guard let self else { return }
            self.alertView.isHidden = true
            self.stopTimer()
            self.navigateToResultScreen()
        }
    }
    
    private func startTimer() {
        guard !isTimerRunning else { return }
        
        isTimerRunning = true
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    static func secondsToTime(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secondsLeft = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, secondsLeft)
    }
    
    // Convert time string (HH:mm:ss) to seconds
    static func timeToSeconds(time: String) -> Int {
        let components = time.split(separator: ":").map { Int($0) ?? 0 }
        let hours = components[0]
        let minutes = components[1]
        let seconds = components[2]
        return (hours * 3600) + (minutes * 60) + seconds
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
    }
    
    private func convertTimeToSeconds(_ time: String) -> Int {
        let components = time.split(separator: ":").compactMap { Int($0) }
        return (components[0]) * 3600 + (components[1]) * 60 + (components[2])
    }
    
    private func navigateToResultScreen() {
        if !UserDefaultsStorage.shared.getGuestValue() {
            saveWorkout { [weak self] in
                guard let self else { return }
                self.delegate?.resetDashboard()
                let vc = presentationAssembly.resultViewController(workout: WorkoutData(id: "", time: timeOfWorkout, closeRange: closeRangeHits, midRangeHits: midRangeHits, longRangeHits: longRangeHits, hitCount: totalHits, total: misses, createdAt: "", userId: ""), delegate: nil)
                self.navigationController?.pushViewController(vc, animated: false)
            }
        } else {
            let vc = presentationAssembly.resultViewController(workout: WorkoutData(id: "", time: timeOfWorkout, closeRange: closeRangeHits, midRangeHits: midRangeHits, longRangeHits: longRangeHits, hitCount: totalHits, total: misses, createdAt: "", userId: ""), delegate: nil)
            self.navigationController?.pushViewController(vc, animated: false)
        }

    }

    private func updateTimeLabel() {
        let time = WorkoutViewController.secondsToTime(seconds: timeInSeconds)
        timeLabel.text = time
    }
    
    private func saveWorkout(completion: (() -> Void)? = nil) {
        workoutParams.userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        workoutParams.time = timeOfWorkout
        workoutParams.closeRange = closeRangeHits
        workoutParams.longRangeHits = longRangeHits
        workoutParams.hitCount = totalHits
        workoutParams.midRangeHits = midRangeHits
        workoutParams.total = misses
        NetworkManager.shared.post(url: "https://online-trainer-16e523bc14c8.herokuapp.com/api/v1/workouts/", parameters: workoutParams.asServiceParams, headers: nil) { [weak self] (result: Result<WorkoutData>) in
            guard let self else { return }
            switch result {
            case .success(let userInfo):
                DispatchQueue.main.async {
                    ProgressView.shared.showProgressHud(animate: false)
                }
                print(userInfo)
                completion?()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    @objc private func timerTick() {
        if timeInSeconds > 0 {
            timeInSeconds -= 1
            timeOfWorkout += 1
            updateTimeLabel()
        } else {
            // Timer finished
            timer?.invalidate()
            timer = nil
            navigateToResultScreen()
        }
    }
    
    @objc func closeButtonTapped() {
        stopTimer()
        handleAlertTap()
    }

    @objc func didTapOnClose() {
        isCloseActive = true
        isMidActive = false
        isLongActive = false
        changeActiveButton()
    }
    
    @objc func didTapOnMid() {
        isMidActive = true
        isCloseActive = false
        isLongActive = false
        changeActiveButton()
    }
    
    @objc func didTapOnLong() {
        isLongActive = true
        isCloseActive = false
        isMidActive = false
        changeActiveButton()
    }
    
    @objc func didTapOnMiss() {
        misses += 1
    }
    
    @objc func didTapOnHit() {
        if isMidActive {
            midRangeHits += 1
        }
        
        if isCloseActive {
            closeRangeHits += 1
        }
        
        if isLongActive {
            longRangeHits += 1
        }
    }
}


public func convertSecondsToTimeString(_ seconds: Double) -> String {
    let hours = Int(seconds) / 3600
    let minutes = (Int(seconds) % 3600) / 60
    let remainingSeconds = Int(seconds) % 60
    
    return String(format: "%02d:%02d:%02d", hours, minutes, remainingSeconds)
}
