import UIKit
import SnapKit

class LaunchScreenViewController: UIViewController {
    
    private lazy var backgroundImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(image: .splashIcon)
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let presentationAssembly: IPresentationAssembly
    private var showAppUpdate: Bool = false
    private var showError = false
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
        setupConstraints()
        navigateNextScreen()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setup() {
        self.view.addSubview(backgroundImage)
    }
    
    private func setupConstraints() {
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func navigateNextScreen() {
        if UserDefaultsStorage.shared.getSignInValue() {
            let dashboardScene = presentationAssembly.mainDashboardScene()
            setWindowRoot(dashboardScene)
        } else {
            let signInScene = presentationAssembly.signInScene()
            setWindowRoot(signInScene)
        }
        
    }
    
    private func setWindowRoot(_ viewController: UIViewController) {
        if #available(iOS 13.0, *) {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        } else {
            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(viewController)
        }
    }
}
