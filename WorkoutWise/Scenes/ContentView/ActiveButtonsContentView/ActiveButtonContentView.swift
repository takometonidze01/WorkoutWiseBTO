import UIKit

class ActiveButtonContentView: UIView, UIContentView {
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
    
    private var chooseItems: [Bool] = []
    private var buttonStates: [Bool] = []

    init(withConfiguration conf: ActiveButtonsContentConfiguration) {
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
        guard let config = configuration as? ActiveButtonsContentConfiguration else {
            return
        }
        
        layout()
        configureStackView(configuration: config)
    }
    
    private func configureStackView(configuration: ActiveButtonsContentConfiguration) {
        hStack.arrangedSubviews.forEach { subview in
            hStack.removeArrangedSubview(subview)
            subview.removeFromSuperview() // Ensure the button is also removed from the view hierarchy
        }

        buttonStates = randomizeButtonStates()
        for item in 0...2 {
            let view = UIButton()
            view.makeRoundedCorners(.allCorners, withRadius: .cornerRadius2)
            view.backgroundColor = red
            view.tag = item
            view.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            
            hStack.addArrangedSubview(view)
        }
    }
    
    private func randomizeButtonStates() -> [Bool] {
        var states = [true, true, false]
        states.shuffle()
        return states
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let config = configuration as? ActiveButtonsContentConfiguration else {
            return
        }
        
        let isActive = buttonStates[sender.tag]
        
        config.didTapOnActiveButton?(sender.tag, isActive)
    }
    
    private func layout() {
        hStack.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
