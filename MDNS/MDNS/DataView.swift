//
//  DataView.swift
//  MDNS
//
//  Created by 童世超 on 2024/7/4.
//

import UIKit

class DataView: UIView {

    private var firstText = ""
    private var secondText = ""
    var sendCallback: ((String) -> Void)?
    
    init(firstText: String = "From Client", secondText: String = "To Client") {
        (self.firstText, self.secondText) = (firstText, secondText)
        super.init(frame: .zero)
        setupUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public

    func resign() {
        toContentTextField.resignFirstResponder()
    }
    
    func setText(_ text: String) {
        fromContentLabel.text = text
    }
    
    // MARK: - Private
    
    @objc private func sendButtonDidClick() {
        guard let text = toContentTextField.text else { return }
        sendCallback?(text)
    }
    
    @objc private func textFieldDidChange(textField: UITextField) {
        
    }
    
    // MARK: - UI
    
    private func setupUI() {
        [sendButton, fromLabel, toLabel, fromContentLabel, toContentTextField].forEach(addSubview)
        fromLabel.text = firstText
        toLabel.text = secondText
        fromLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview()
        }
        fromContentLabel.snp.makeConstraints { make in
            make.top.equalTo(fromLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        toLabel.snp.makeConstraints { make in
            make.top.equalTo(fromContentLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }
        toContentTextField.snp.makeConstraints { make in
            make.top.equalTo(toLabel.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalTo(sendButton.snp.left).offset(-20)
            make.height.equalTo(60)
        }
        sendButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.bottom.equalTo(toContentTextField)
            make.width.equalTo(60)
        }
    }

    // MARK: lazy load
    
    private lazy var sendButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Send", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.addTarget(self, action: #selector(sendButtonDidClick), for: .touchUpInside)
        return btn
    }()

    private lazy var fromLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .black
        label.text = "From Client"
        return label
    }()
    
    private lazy var toLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .black
        label.text = "To Client"
        return label
    }()
    
    private lazy var fromContentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .white
        label.backgroundColor = .black
        label.text = ""
        return label
    }()
    
    private(set) lazy var toContentTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.returnKeyType = .done
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
        textField.backgroundColor = .black
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
}

extension DataView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resign()
        return true
    }
}
