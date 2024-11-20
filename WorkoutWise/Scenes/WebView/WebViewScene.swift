import UIKit
import WebKit
import SnapKit

class WebViewController: UIViewController {
    private var webView: WKWebView!
    private var urlString: String
    private let presentationAssembly: IPresentationAssembly
    
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setTitle("X", for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return closeButton
    }()
    
    private var closeButtonIsHidden: Bool

    init(urlString: String, presentationAssembly: IPresentationAssembly, closeButtonIsHidden: Bool) {
        self.urlString = urlString
        self.presentationAssembly = presentationAssembly
        self.closeButtonIsHidden = closeButtonIsHidden
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = black
        closeButton.isHidden = closeButtonIsHidden
        setupWebView()
        loadWebPage()
    }
    
    private func setupWebView() {
        webView = WKWebView()
        view.addSubview(webView)
        view.addSubview(closeButton)

        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        webView.snp.makeConstraints { make in
            if closeButtonIsHidden {
                make.top.equalToSuperview()
            } else {
                make.top.equalTo(closeButton.snp.bottom).offset(10)
            }
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func loadWebPage() {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }

    @objc private func closeButtonTapped() {
        self.navigationController?.popViewController(animated: false)
    }
}


