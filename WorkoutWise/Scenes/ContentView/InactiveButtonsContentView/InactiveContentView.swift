import UIKit

class InactiveContentView: UIView, UIContentView {
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    private lazy var hStack: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 4
        return view
    }()
    
    init(withConfiguration conf: InactiveContentConfiguration) {
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
        addSubview(hStack)
    }
    
    private func configure(configuration: UIContentConfiguration) {
        guard let config = configuration as? InactiveContentConfiguration else {
            return
        }
        
        layout()
        configureStackView(configuration: config)
    }
    
    private func configureStackView(configuration: InactiveContentConfiguration) {
        guard let config = configuration as? InactiveContentConfiguration else {
            return
        }

        hStack.arrangedSubviews.forEach { subview in
            hStack.removeArrangedSubview(subview)
            subview.removeFromSuperview() 
        }

        for item in 0...2 {
            let view = UIView()
            view.makeRoundedCorners(.allCorners, withRadius: .cornerRadius2)
            view.backgroundColor = gray
            
            let iconImage = UIImageView(frame: .zero)
            
            view.addSubview(iconImage)
            
            if let randomItem = config.gameRandomItem {
                if item == randomItem.index {
                    iconImage.isHidden = false
                } else {
                    iconImage.isHidden = true
                }
                
                iconImage.image = randomItem.isActive ? UIImage(image: .logo) : UIImage(image: .gameOver)
            }
            iconImage.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.size.equalTo(CGFloat(32.0).scaledWidth)
            }
            
            hStack.addArrangedSubview(view)
        }
    }
    
    private func layout() {
        hStack.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
