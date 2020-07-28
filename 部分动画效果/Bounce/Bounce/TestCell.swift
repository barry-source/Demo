//
//  TestCell.swift
//  Bounce
//
//  Created by TSC on 2020/2/27.
//  Copyright © 2020 TSC. All rights reserved.
//

import UIKit

class TestCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        contentView.backgroundColor = .orange
        contentView.addSubview(shadowContainerView)
        shadowContainerView.addSubview(containerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowContainerView.frame = CGRect(x: 20, y: 20, width: frame.size.width - 40, height: frame.size.height - 40)
        containerView.frame = shadowContainerView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.clipsToBounds = true;
        containerView.layer.cornerRadius = 30;
        return containerView
    }()
    
    lazy var shadowContainerView: UIView = {
        let shadowContainerView = UIView()
        shadowContainerView.backgroundColor = .white
        shadowContainerView.layer.shadowColor = UIColor(red: 0xcd / 255.0, green: 0xcd / 255.0, blue: 0xcd / 255.0, alpha: 1.0).cgColor
        shadowContainerView.layer.shadowOpacity = 1
        shadowContainerView.layer.shadowRadius = 9.0
        shadowContainerView.layer.cornerRadius = 9.0
        shadowContainerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        shadowContainerView.clipsToBounds = false
        return shadowContainerView
    }()
}

extension TestCell {
    func startAnimation() {
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.curveLinear], animations: {
            self.shadowContainerView.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
        }) { (finish) in
            self.isUserInteractionEnabled = true
        }
    }
    
    func endAnimation() {
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
            self.shadowContainerView.transform = CGAffineTransform.identity
        }) { (finish) in
            self.isUserInteractionEnabled = true
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }
}
