import UIKit
class AlertView: UIView {
    private lazy var wrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = gray
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .semiBold14()
        label.textColor = white
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .medium14()
        label.textColor = white.withAlphaComponent(0.4)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = red
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(white, for: .normal)
        button.titleLabel?.font = .medium14()
        button.addTarget(self, action: #selector(didTapOnCancelBtn), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = black
        button.setTitle("Yes", for: .normal)
        button.setTitleColor(white, for: .normal)
        button.titleLabel?.font = .medium14()
        button.addTarget(self, action: #selector(didTapOnDeleteBtn), for: .touchUpInside)
        return button
    }()
    
    public var didTapOnCancelButton: (() -> Void)?
    public var didTapOnDeleteButton: (() -> Void)?
    
    init(title: String, description: String, cancelButtonTitle: String? = nil, deleteButtonTitle: String? = nil) {
        super.init(frame: .zero)
        setupView(
            title: title,
            description: description,
            cancelButtonTitle: cancelButtonTitle,
            deleteButtonTitle: deleteButtonTitle
        )
        
        backgroundColor = black.withAlphaComponent(0.6)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        wrapperView.makeRoundedCorners(.allCorners, withRadius: .cornerRadius2)
        cancelButton.makeRoundedCorners(.allCorners, withRadius: .cornerRadius2)
        deleteButton.makeRoundedCorners(.allCorners, withRadius: .cornerRadius2)
    }
    
    private func setupView(title: String, description: String, cancelButtonTitle: String? = nil, deleteButtonTitle: String? = nil) {
        addSubview(wrapperView)
        wrapperView.addSubview(titleLabel)
        wrapperView.addSubview(descriptionLabel)
        wrapperView.addSubview(deleteButton)
        wrapperView.addSubview(cancelButton)
        
        titleLabel.text = title
        descriptionLabel.text = description
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        deleteButton.setTitle(deleteButtonTitle, for: .normal)
        
        wrapperView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(CGFloat(233.0).scaledWidth)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat(20.0).scaledWidth)
            make.leading.trailing.equalToSuperview().inset(CGFloat(20.0).scaledWidth)
        }
        
        descriptionLabel.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(CGFloat(20.0).scaledWidth)
            make.leading.trailing.equalToSuperview().inset(CGFloat(20.0).scaledWidth)
        }
        
        cancelButton.snp.remakeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(CGFloat.spacing7.scaledWidth)
            make.trailing.equalToSuperview().inset(CGFloat(20.0).scaledWidth)
            make.height.equalTo(CGFloat(40.0).scaledWidth)
            make.width.equalTo(CGFloat(170.0).scaledWidth)
        }
        
        deleteButton.snp.remakeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(CGFloat.spacing7.scaledWidth)
            make.leading.equalToSuperview().inset(CGFloat(20.0).scaledWidth)
            make.height.equalTo(CGFloat(40.0).scaledWidth)
            make.width.equalTo(CGFloat(170.0).scaledWidth)
            
        }
    }
    
    @objc private func didTapOnCancelBtn() {
        didTapOnCancelButton?()
    }
    
    @objc private func didTapOnDeleteBtn() {
        didTapOnDeleteButton?()
    }
}
