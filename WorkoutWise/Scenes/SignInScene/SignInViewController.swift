import UIKit
import AuthenticationServices

class SignInViewController: UIViewController {
    private let presentationAssembly: IPresentationAssembly
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(image: .signIn)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = .semiBold32()
        view.text = "Ensure safe use"
        view.textColor = white
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = .semiBold16()
        view.text = "Connect your Apple account to protect your data and training history and use the application without worry"
        view.numberOfLines = 0
        view.textColor = white.withAlphaComponent(0.4)
        return view
    }()
    
    private lazy var primaryButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.configuration = .filled()
        view.configuration?.baseBackgroundColor = .white
        view.backgroundColor = .white
        view.makeRoundedCorners(.allCorners, withRadius: 12 * Constraints.yCoeff)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = .medium12()
        view.setTitle("Sign In with Apple", for: .normal)
        view.addTarget(self, action: #selector(didTapOnPrimaryButton), for: .touchUpInside)
        view.setImage(UIImage(systemName: "apple.logo")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        view.configuration?.imagePadding = 10
        view.dropShadow()
        return view
    }()
    
    private lazy var secondaryButton: UILabel = {
        let view = UILabel(frame: .zero)
        view.backgroundColor = .clear
        view.textColor = white.withAlphaComponent(0.4)
        view.font = .medium12()
        view.numberOfLines = 0
        view.textAlignment = .center
        
        let baseText = "Click 'Sing Up' to accept our Terms and Privacy\nPolicy!"
        
        let attributedTitle = NSMutableAttributedString(string: baseText)
        
        let termsRange = (baseText as NSString).range(of: "Terms")
        let privacyRange = (baseText as NSString).range(of: "Privacy\nPolicy!")
        let signUpRange = (baseText as NSString).range(of: "'Sing Up'")
        
        attributedTitle.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: termsRange)
        attributedTitle.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: privacyRange)
        attributedTitle.addAttribute(.foregroundColor, value: white, range: termsRange)
        attributedTitle.addAttribute(.foregroundColor, value: white, range: privacyRange)
        attributedTitle.addAttribute(.foregroundColor, value: white, range: signUpRange)
        
        view.attributedText = attributedTitle
        
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLabel(_:)))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var guestButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.backgroundColor = gray
        view.makeRoundedCorners(.allCorners, withRadius: 12 * Constraints.yCoeff)
        view.setTitleColor(white, for: .normal)
        view.titleLabel?.font = .medium12()
        view.setTitle("log in as guest", for: .normal)
        view.addTarget(self, action: #selector(didTapOnGuestButton), for: .touchUpInside)
        view.dropShadow()
        return view
    }()
    
    private var userInfo: UserParams = .initial()
    
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
        
        view.backgroundColor = black
        setup()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc private func didTapLabel(_ sender: UITapGestureRecognizer) {
        let url = "https://www.freeprivacypolicy.com/live/99201360-fa0b-4b48-bd90-a44be9c532a3"
        
        self.navigateWebViewScene(url: url)
    }
    
    private func setup() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(primaryButton)
        view.addSubview(guestButton)
        view.addSubview(secondaryButton)
    }
    
    private func navigateWebViewScene(url: String) {
        let vc = presentationAssembly.navigateWebView(url: url, closeButtonIsHidden: false)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func layout() {
        imageView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat(199.0).scaledWidth)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGFloat(143.0).scaledWidth)
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-CGFloat(20.0).scaledHeight)
            make.leading.trailing.equalToSuperview().inset(CGFloat(20).scaledWidth)
        }
        
        descriptionLabel.snp.remakeConstraints { make in
            make.bottom.equalTo(secondaryButton.snp.top).offset(-CGFloat(80.0).scaledWidth)
            make.leading.trailing.equalToSuperview().inset(CGFloat(20.0).scaledWidth)
        }
        
        primaryButton.snp.remakeConstraints { make in
            make.bottom.equalTo(guestButton.snp.top).offset(-CGFloat.spacing7.scaledHeight)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(CGFloat.spacing4.scaledWidth)
            make.height.equalTo(CGFloat(40.0).scaledWidth)
        }
        
        guestButton.snp.remakeConstraints { make in
            make.bottom.equalToSuperview().offset(-CGFloat.spacing3.scaledHeight)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(CGFloat.spacing4.scaledWidth)
            make.height.equalTo(CGFloat(40.0).scaledWidth)
        }
        
        secondaryButton.snp.remakeConstraints { make in
            make.bottom.equalTo(primaryButton.snp.top).offset(-CGFloat(20.0).scaledHeight)
            make.centerX.equalToSuperview()
            make.width.equalTo(CGFloat(298.0).scaledWidth)
            make.height.equalTo(CGFloat(50.0).scaledWidth)
        }
    }
    
    @objc func didTapOnPrimaryButton() {
        UserDefaultsStorage.shared.changeGuest(value: false)
        UserDefaultsStorage.shared.changeSignIn(value: true)
        let authorizationProvider = ASAuthorizationAppleIDProvider()
        let request = authorizationProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    @objc func didTapOnSecondaryButton() {
        let url = "https://www.freeprivacypolicy.com/live/99201360-fa0b-4b48-bd90-a44be9c532a3"
        
        self.navigateWebViewScene(url: url)
    }
    
    private func showAlert(title: String, description: String?) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func createUser() {
        ProgressView.shared.showProgressHud(animate: true)
        let apppleToken = UserDefaults.standard.string(forKey: "AccountCredential")
        var pushToken = UserDefaults.standard.string(forKey: "PushToken")
        if pushToken == nil {
            pushToken = ""
        }
        
        userInfo.appleToken = apppleToken ?? ""
        userInfo.pushToken = pushToken
        NetworkManager.shared.post(url: "https://online-trainer-16e523bc14c8.herokuapp.com/api/v1/users/", parameters: userInfo.asServiceParams, headers: nil) { [weak self] (result: Result<UserInfo>) in
            guard let self else { return }
            switch result {
            case .success(let userInfo):
                DispatchQueue.main.async {
                    ProgressView.shared.showProgressHud(animate: false)
                    self.navigateMainDashboard()
                }
                print(userInfo)
                UserDefaults.standard.setValue(userInfo.id, forKey: "userId")
            case .failure(let error):
                DispatchQueue.main.async {
                    ProgressView.shared.showProgressHud(animate: false)
                    self.showAlert(title: "", description: error.localizedDescription)
                }
                print("Error: \(error)")
            }
        }
    }
    
    private func navigateMainDashboard() {
        UserDefaultsStorage.shared.changeUserInAppValue(on: true)
        UserDefaultsStorage.shared.changeSignIn(value: true)
        setRootVc()
    }
    
    private func setRootVc() {
        let vc = presentationAssembly.mainDashboardScene()
        let navigationController = UINavigationController(rootViewController: vc)
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        if let window = windowScene?.windows.first {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
    
    @objc func didTapOnGuestButton() {
        UserDefaultsStorage.shared.changeGuest(value: true)
        setRootVc()
    }
}

extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        UserDefaults.standard.setValue(credential.user, forKey: "AccountCredential")
        createUser()
    }
}
