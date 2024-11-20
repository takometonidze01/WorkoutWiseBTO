import UIKit

class HistoryContentView: UIView, UIContentView {
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    private lazy var wrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = gray
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .semiBold14()
        label.textColor = white
        label.text = "Morning workout"
        return label
    }()
    
    private lazy var borderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.4)
        return view
    }()
    
    private lazy var calendarIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(image: .calendar))
        imageView.tintColor = .label
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .medium12()
        label.textColor = .white.withAlphaComponent(0.4)
        label.text = "02 May 2023"
        return label
    }()
    
    private lazy var repeatIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(image: .repeatIcon))
        imageView.tintColor = .label
        return imageView
    }()
    
    private lazy var repeatLabel: UILabel = {
        let label = UILabel()
        label.font = .medium12()
        label.textColor = .white.withAlphaComponent(0.4)
        label.text = "40 minutes"
        return label
    }()
    
    private lazy var primaryButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white.withAlphaComponent(0.4), for: .normal)
        button.titleLabel?.font = .medium14()
        button.backgroundColor = black
        button.setTitle("View in full", for: .normal)
        button.addTarget(self, action: #selector(didTapOnPrimaryButton), for: .touchUpInside)
        return button
    }()

    init(withConfiguration conf: HistoryContentConfiguration) {
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
        
        wrapperView.makeRoundedCorners(.allCorners, withRadius: .cornerRadius1)
        primaryButton.makeRoundedCorners(.allCorners, withRadius: .cornerRadius2)
    }
    
    private func setup() {
        addSubview(wrapperView)
        wrapperView.addSubview(titleLabel)
        wrapperView.addSubview(borderLine)
        wrapperView.addSubview(calendarIcon)
        wrapperView.addSubview(dateLabel)
        wrapperView.addSubview(repeatIcon)
        wrapperView.addSubview(repeatLabel)
        wrapperView.addSubview(primaryButton)
    }
    
    private func configure(configuration: UIContentConfiguration) {
        guard let config = configuration as? HistoryContentConfiguration else {
            return
        }
        
        guard let historyData = config.workoutData else {
            return
        }
        
        repeatLabel.text = "\(secondsToTime(seconds: historyData.time))"
        convertDateAndTitle(from: historyData.createdAt)

        layout()
    }
    
    func convertDateAndTitle(from timestamp: String) {
        // Convert timestamp string to Date object
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        guard let date = dateFormatter.date(from: timestamp) else {
            return
        }
        
        // Format the date into desired format
        let displayDateFormatter = DateFormatter()
        displayDateFormatter.dateFormat = "dd MMM yyyy"
        let formattedDate = displayDateFormatter.string(from: date)
        
        // Get the hour from the date to determine the time of day
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        // Set the title based on the time of day
        var title = "Workout"
        if hour >= 5 && hour < 12 {
            title = "Morning workout"
        } else if hour >= 12 && hour < 17 {
            title = "Afternoon workout"
        } else {
            title = "Evening workout"
        }
        
        dateLabel.text = formattedDate
        titleLabel.text = title
    }

    func secondsToTime(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secondsLeft = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, secondsLeft)
    }


    @objc private func didTapOnPrimaryButton() {
        guard let config = configuration as? HistoryContentConfiguration else {
            return
        }

        config.didTapOnViewFullButton?()
    }
    
    private func layout() {
        wrapperView.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(CGFloat.spacing7.scaledWidth)
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat(20.0).scaledWidth)
            make.leading.trailing.equalToSuperview().inset(CGFloat(20.0).scaledWidth)
        }
        
        borderLine.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(CGFloat(20.0).scaledWidth)
            make.leading.trailing.equalToSuperview().inset(CGFloat(20.0).scaledWidth)
            make.height.equalTo(CGFloat(1.0))
        }
        
        calendarIcon.snp.remakeConstraints { make in
            make.top.equalTo(borderLine.snp.bottom).offset(CGFloat.spacing7.scaledWidth)
            make.leading.equalToSuperview().inset(CGFloat(20.0).scaledWidth)
            make.size.equalTo(CGFloat(20.0).scaledWidth)
        }
        
        dateLabel.snp.remakeConstraints { make in
            make.leading.equalTo(calendarIcon.snp.trailing).offset(CGFloat(6.0).scaledWidth)
            make.centerY.equalTo(calendarIcon.snp.centerY)
        }
        
        repeatIcon.snp.remakeConstraints { make in
            make.top.equalTo(borderLine.snp.bottom).offset(CGFloat.spacing7.scaledWidth)
            make.leading.equalTo(dateLabel.snp.trailing).offset(CGFloat(20.0).scaledWidth)
            make.size.equalTo(CGFloat(20.0).scaledWidth)
        }
        
        repeatLabel.snp.remakeConstraints { make in
            make.leading.equalTo(repeatIcon.snp.trailing).offset(CGFloat(6.0).scaledWidth)
            make.centerY.equalTo(calendarIcon.snp.centerY)
        }
        
        primaryButton.snp.remakeConstraints { make in
            make.top.equalTo(repeatIcon.snp.bottom).offset(CGFloat.spacing7.scaledWidth)
            make.leading.trailing.equalToSuperview().inset(CGFloat(20.0).scaledWidth)
            make.height.equalTo(CGFloat(40.0).scaledWidth)
        }
    }
}
