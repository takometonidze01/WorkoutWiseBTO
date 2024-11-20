import UIKit

class PushNotificationViewController: UIViewController {
    private let presentationAssembly: IPresentationAssembly
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(image: .pushNotification)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = .bold18()
        view.text = "Enable Push Notifications Now"
        view.textAlignment = .center
        view.textColor = white
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = .semiBold16()
        view.text = "Connect notifications and receive\nnews from applications first"
        view.numberOfLines = 0
        view.textAlignment = .center
        view.textColor = white
        return view
    }()
    
    private lazy var primaryButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.backgroundColor = red
        view.makeRoundedCorners(.allCorners, withRadius: 12 * Constraints.yCoeff)
        view.setTitleColor(white, for: .normal)
        view.titleLabel?.font = .bold18()
        view.setTitle("Get Notified", for: .normal)
        view.addTarget(self, action: #selector(didTapOnPrimaryButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var secondaryButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.backgroundColor = .clear
        view.makeRoundedCorners(.allCorners, withRadius: 12 * Constraints.yCoeff)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = .bold18()
        view.setTitle("Later", for: .normal)
        view.addTarget(self, action: #selector(didTapOnSecondaryButton), for: .touchUpInside)
        return view
    }()

    
    init(
        presentationAssembly: IPresentationAssembly
    ) {
        self.presentationAssembly = presentationAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setup() {
        view.backgroundColor = black
    
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(primaryButton)
        view.addSubview(secondaryButton)
    }
    
    private func layout() {
        imageView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat(226.0).scaledWidth)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGFloat(137.0).scaledWidth)
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(CGFloat.spacing2.scaledHeight)
            make.leading.trailing.equalToSuperview().inset(CGFloat.spacing4.scaledWidth)
        }
        
        descriptionLabel.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(CGFloat(12.0).scaledWidth)
            make.leading.trailing.equalToSuperview().inset(CGFloat.spacing4.scaledWidth)
        }
        
        primaryButton.snp.remakeConstraints { make in
            make.bottom.equalTo(secondaryButton.snp.top).offset(-CGFloat(12.0).scaledHeight)
            make.centerX.equalToSuperview()
            make.width.equalTo(CGFloat(181.0).scaledWidth)
            make.height.equalTo(CGFloat(49.0).scaledWidth)
        }
        
        secondaryButton.snp.remakeConstraints { make in
            make.bottom.equalToSuperview().offset(-CGFloat.spacing3.scaledHeight)
            make.centerX.equalToSuperview()
            make.width.equalTo(CGFloat(181.0).scaledWidth)
            make.height.equalTo(CGFloat(49.0).scaledWidth)
        }
    }
    
    @objc func didTapOnPrimaryButton() {
        registerForPushNotifications() {
            UserDefaultsStorage.shared.changePushAsked(value: true)
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                let vc = presentationAssembly.signInScene()
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
    @objc func didTapOnSecondaryButton() {
        UserDefaultsStorage.shared.changePushAsked(value: true)
        let vc = presentationAssembly.signInScene()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    private func registerForPushNotifications(completionHandler: @escaping () -> Void) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                completionHandler()
                guard granted else { return }
                self?.getNotificationSettings()
            }
    }
    
    private func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    let vc = presentationAssembly.signInScene()
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
        }
    }
}
