//
//  SimpleTextView.swift
//  Skull
//
//  Created by Tako Metonidze on 11/12/24.
//

import UIKit

class ResultWrapperView: UIView {
    private lazy var wrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = gray
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .medium24()
        label.textColor = white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .medium12()
        label.textColor = white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        wrapperView.makeRoundedCorners(.allCorners, withRadius: .cornerRadius2)
    }
    
    private func setup() {
        addSubview(wrapperView)
        wrapperView.addSubview(titleLabel)
        wrapperView.addSubview(descriptionLabel)
    }
    
    private func layout() {
        wrapperView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        descriptionLabel.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(CGFloat.spacing5.scaledWidth)
            make.leading.trailing.equalToSuperview().inset(CGFloat.spacing8.scaledWidth)
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(CGFloat.spacing8.scaledWidth)
            make.leading.trailing.equalToSuperview().inset(CGFloat.spacing7.scaledWidth)
        }
    }
    
    func setTitleAndDescription(
        title: String,
        description: String
    ) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
