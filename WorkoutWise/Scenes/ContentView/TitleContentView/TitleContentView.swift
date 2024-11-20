import UIKit

class TitleContentView: UIView, UIContentView {
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your statistics"
        label.font = .medium16()
        label.textColor = white
        return label
    }()

    init(withConfiguration conf: TitleContentConfiguration) {
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
        addSubview(titleLabel)
    }
    
    private func configure(configuration: UIContentConfiguration) {
        guard let config = configuration as? TitleContentConfiguration else {
            return
        }
        
        titleLabel.text = config.title
        layout()
    }

    private func layout() {
        titleLabel.snp.remakeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(CGFloat(20.0).scaledWidth)
        }
    }
}
