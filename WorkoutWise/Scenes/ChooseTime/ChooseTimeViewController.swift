//
//  ChooseTimeViewController.swift
//  Skull
//
//  Created by Tako Metonidze on 11/9/24.
//

import UIKit

protocol ChooseTimeDelegate: AnyObject {
    func didChooseTime(_ time: String)
}

import UIKit

class ChooseTimeViewController: UIViewController {
    private let presentationAssembly: IPresentationAssembly
    weak var delegate: ChooseTimeDelegate?
    
    private var totalSeconds: Int = 0 {
        didSet {
            timeLabel.text = timeString(from: totalSeconds)
        }
    }
    
    private let maxTimeInSeconds = 24 * 60 * 60 // Max 24 hours in seconds
    
    private lazy var wrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = gray
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "How long do you want to train?"
        label.font = .semiBold14()
        label.textColor = white
        return label
    }()
    
    private lazy var minusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(image: .minus), for: .normal)
        button.backgroundColor = black
        button.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        return button
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
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(image: .plus), for: .normal)
        button.backgroundColor = black
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(white, for: .normal)
        button.backgroundColor = black
        button.titleLabel?.font = .medium14()
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(white, for: .normal)
        button.backgroundColor = red
        button.titleLabel?.font = .medium14()
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        setup()
        layout()
        updateTimeLabel()
    }
    
    init(
        delegate: ChooseTimeDelegate?,
        presentationAssembly: IPresentationAssembly
    ) {
        self.delegate = delegate
        self.presentationAssembly = presentationAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        wrapperView.makeRoundedCorners(.onlyTopCorners, withRadius: .cornerRadius2)
        minusButton.makeRoundedCorners(.allCorners, withRadius: .cornerRadius2)
        timeWrapperView.makeRoundedCorners(.allCorners, withRadius: .cornerRadius2)
        plusButton.makeRoundedCorners(.allCorners, withRadius: .cornerRadius2)
        cancelButton.makeRoundedCorners(.allCorners, withRadius: .cornerRadius2)
        startButton.makeRoundedCorners(.allCorners, withRadius: .cornerRadius2)
    }
    
    private func setup() {
        view.addSubview(wrapperView)
        wrapperView.addSubview(titleLabel)
        wrapperView.addSubview(minusButton)
        wrapperView.addSubview(timeWrapperView)
        timeWrapperView.addSubview(timeLabel)
        wrapperView.addSubview(plusButton)
        wrapperView.addSubview(cancelButton)
        wrapperView.addSubview(startButton)
    }
    
    private func layout() {
        wrapperView.snp.remakeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(CGFloat(213.0).scaledWidth)
        }

        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat(28.0).scaledWidth)
            make.leading.equalToSuperview().offset(CGFloat(20.0).scaledWidth)
        }
        
        minusButton.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(CGFloat(20.0).scaledWidth)
            make.leading.equalToSuperview().offset(CGFloat(20.0).scaledWidth)
            make.height.equalTo(CGFloat(40.0).scaledWidth)
            make.width.equalTo(CGFloat(75.5).scaledWidth)
        }
        
        timeWrapperView.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(CGFloat(20.0).scaledWidth)
            make.height.equalTo(CGFloat(40.0).scaledWidth)
            make.leading.equalTo(minusButton.snp.trailing).offset(CGFloat(10.0).scaledWidth)
            make.trailing.equalTo(plusButton.snp.leading).offset(-CGFloat(10.0).scaledWidth)
        }
        
        timeLabel.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        plusButton.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(CGFloat(20.0).scaledWidth)
            make.trailing.equalToSuperview().offset(-CGFloat(20.0).scaledWidth)
            make.height.equalTo(CGFloat(40.0).scaledWidth)
            make.width.equalTo(CGFloat(75.5).scaledWidth)
        }
        
        cancelButton.snp.remakeConstraints { make in
            make.top.equalTo(timeWrapperView.snp.bottom).offset(CGFloat(20.0).scaledWidth)
            make.leading.equalToSuperview().offset(CGFloat(20.0).scaledWidth)
            make.height.equalTo(CGFloat(40.0).scaledWidth)
            make.width.equalTo(CGFloat(170.0).scaledWidth)
        }
        
        startButton.snp.remakeConstraints { make in
            make.top.equalTo(timeWrapperView.snp.bottom).offset(CGFloat(20.0).scaledWidth)
            make.trailing.equalToSuperview().offset(-CGFloat(20.0).scaledWidth)
            make.height.equalTo(CGFloat(40.0).scaledWidth)
            make.width.equalTo(CGFloat(170.0).scaledWidth)
        }
    }
    
    @objc func plusButtonTapped() {
        // Increment time by 10 minutes (600 seconds)
        totalSeconds += 600
        if totalSeconds > maxTimeInSeconds {
            totalSeconds = maxTimeInSeconds
        }
    }
    
    @objc func minusButtonTapped() {
        // Decrement time by 10 minutes (600 seconds)
        totalSeconds -= 600
        if totalSeconds < 0 {
            totalSeconds = 0
        }
    }
    
    @objc func startButtonTapped() {
        self.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            delegate?.didChooseTime(timeLabel.text ?? "00:00:00")
        }
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Format time in "HH:mm:ss" from seconds
    private func timeString(from seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secondsLeft = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, secondsLeft)
    }
    
    private func updateTimeLabel() {
        totalSeconds = 0 // Initialize to 00:00:00
    }
}
