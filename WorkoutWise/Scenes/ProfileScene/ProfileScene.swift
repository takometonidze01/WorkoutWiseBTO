import UIKit
import StoreKit

public enum ProfileSceneSectionID: String {
    case active
    case inactive
    case testing
    
}

class ProfileScene: UIViewController {
    private let presentationAssembly: IPresentationAssembly
    private let userPoint: String

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(image: .close), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(image: .settingIcon))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var termOfUseView: ProfileSceneView = {
        let view = ProfileSceneView()
        view.setTitle("Terms of use")
        return view
    }()
    
    private lazy var privacyPolicyView: ProfileSceneView = {
        let view = ProfileSceneView()
        view.setTitle("Privacy policy")
        return view
    }()
    
    private lazy var supportView: ProfileSceneView = {
        let view = ProfileSceneView()
        view.setTitle("Support")
        return view
    }()
    
    private lazy var rateUsView: ProfileSceneView = {
        let view = ProfileSceneView()
        view.setTitle("Rate us")
        return view
    }()
    
    private lazy var deleteAccountView: ProfileSceneView = {
        let view = ProfileSceneView()
        view.setTitle("Delete account")
        view.setTitleColor(red)
        view.hideWrapperView()
        return view
    }()
    
    private lazy var deleteAccountAlertView: AlertView = {
        let view = AlertView(title: "Are you sure?", description: "Are you sure you want to delete your account, this action cannot be canceled once confirmed", cancelButtonTitle: "Cancel", deleteButtonTitle: "Delete")
      view.isHidden = true
      return view
    }()
    
    init(
        userPoint: String,
        presentationAssembly: IPresentationAssembly
        
    ) {
        self.userPoint = userPoint
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
        
        supportView.didTap = { [weak self] in
            guard let self else { return }
            
            self.navigateWebViewScene(url: "https://form.jotform.com/243124714251447")
        }
        
        termOfUseView.didTap = { [weak self] in
            guard let self else { return }
            
            self.navigateWebViewScene(url: "")
        }

        privacyPolicyView.didTap = { [weak self] in
            guard let self else { return }

            
            self.navigateWebViewScene(url: "https://www.freeprivacypolicy.com/live/66c89a53-d5b9-429b-b064-e3e83a26c8a7")
        }
        
        
        deleteAccountView.didTap = { [weak self] in
            guard let self else { return }
            
            handleAccountDeleteAlertTap()
        }
    }
    
    private func navigateWebViewScene(url: String) {
        let vc = presentationAssembly.navigateWebView(url: url, closeButtonIsHidden: false)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleAccountDeleteAlertTap() {
        deleteAccountAlertView.isHidden = false
        
        deleteAccountAlertView.didTapOnCancelButton = { [weak self] in
            guard let self else { return }
            self.deleteAccountAlertView.isHidden = true
        }
        
        deleteAccountAlertView.didTapOnDeleteButton = { [weak self] in
            guard let self else { return }
            self.deleteAccountAlertView.isHidden = true
            deleteAccount()
        }
    }
    
    private func deleteAccount() {
        let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        ProgressView.shared.showProgressHud(animate: true)
        NetworkManager.shared.delete(url: "https://online-trainer-16e523bc14c8.herokuapp.com/api/v1/users/\(userId)", parameters: nil, headers: nil) { (result: Result<DeleteUserResponse>) in
            switch result {
            case .success(let exercises):
                DispatchQueue.main.async {
                    ProgressView.shared.showProgressHud(animate: false)
                    self.changeRootViewController()
                }
            case .failure(let error):
                print("Error: \(error)")
                DispatchQueue.main.async {
                    ProgressView.shared.showProgressHud(animate: false)
                }
            }
        }
    }
    
    private func changeRootViewController() {
        UserDefaultsStorage.shared.changeSignIn(value: false)
        UserDefaultsStorage.shared.changeRegisterAsked(value: false)
        UserDefaultsStorage.shared.changeUserInAppValue(on: false)
        UserDefaults.standard.removeObject(forKey: "AccountCredential")
        UserDefaults.standard.removeObject(forKey: "userId")

        let signInViewController = presentationAssembly.signInScene()

        let navigationController = UINavigationController(rootViewController: signInViewController)

        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        if let window = windowScene?.windows.first {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setup() {
        view.addSubview(iconImageView)
        view.addSubview(backButton)
        view.addSubview(termOfUseView)
        view.addSubview(privacyPolicyView)
        view.addSubview(supportView)
        view.addSubview(rateUsView)
        view.addSubview(deleteAccountView)
        view.addSubview(deleteAccountAlertView)
    }
    
    private func layout() {
        backButton.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat.spacing1.scaledWidth)
            make.leading.equalToSuperview().offset(CGFloat(20).scaledWidth)
            make.size.equalTo(CGFloat(24.0).scaledWidth)
        }
        
        termOfUseView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat(294.0).scaledHeight)
            make.leading.trailing.equalToSuperview().inset(CGFloat(110.0).scaledWidth)
            make.height.equalTo(CGFloat(44.0).scaledWidth)
        }
        
        privacyPolicyView.snp.remakeConstraints { make in
            make.top.equalTo(termOfUseView.snp.bottom).offset(CGFloat.spacing8.scaledHeight)
            make.leading.trailing.equalToSuperview().inset(CGFloat(110.0).scaledWidth)
            make.height.equalTo(CGFloat(44.0).scaledWidth)
        }
        
        supportView.snp.remakeConstraints { make in
            make.top.equalTo(privacyPolicyView.snp.bottom).offset(CGFloat.spacing8.scaledHeight)
            make.leading.trailing.equalToSuperview().inset(CGFloat(110.0).scaledWidth)
            make.height.equalTo(CGFloat(44.0).scaledWidth)
        }
        
        rateUsView.snp.remakeConstraints { make in
            make.top.equalTo(supportView.snp.bottom).offset(CGFloat.spacing8.scaledHeight)
            make.leading.trailing.equalToSuperview().inset(CGFloat(110.0).scaledWidth)
            make.height.equalTo(CGFloat(44.0).scaledWidth)
        }
        
        deleteAccountView.snp.remakeConstraints { make in
            make.top.equalTo(rateUsView.snp.bottom).offset(CGFloat.spacing5.scaledHeight)
            make.leading.trailing.equalToSuperview().inset(CGFloat(110.0).scaledWidth)
            make.height.equalTo(CGFloat(44.0).scaledWidth)
        }
        
        deleteAccountAlertView.snp.remakeConstraints { make in
          make.edges.equalToSuperview()
        }
    }
    
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
