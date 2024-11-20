import UIKit

class ProfileSceneView: UIView {
    private lazy var wrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = gray
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Terms of use"
        label.font = .medium14()
        label.textColor = .white
        return label
    }()
    
    var didTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        layout()
        addTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        wrapperView.makeRoundedCorners(.allCorners, withRadius: .cornerRadius2)
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        wrapperView.addGestureRecognizer(tapGesture)
        wrapperView.isUserInteractionEnabled = true // Ensure the view can respond to touches
    }

    private func setup() {
        addSubview(wrapperView)
        wrapperView.addSubview(titleLabel)
    }
    
    private func layout() {
        wrapperView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.center.top.equalToSuperview()
        }
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }

    func hideWrapperView() {
        wrapperView.backgroundColor = .clear
    }
    
    func setTitleColor(_ color: UIColor) {
        titleLabel.textColor = color
    }
    
    @objc private func handleTap() {
        didTap?()
    }
}
