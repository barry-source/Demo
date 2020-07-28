//
//  TestTableViewCell.swift
//  CakeAnimation
//
//  Created by TSC on 2020/3/6.
//  Copyright © 2020 tongshichao. All rights reserved.
//

import UIKit

class TestTableViewCell: UITableViewCell {

    var label: UILabel!
    var button: UIButton!
    
    var clickCallback: (() -> Void)?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        label = UILabel(frame: .zero)
        label.text = "测试动画执行时的滚动"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        contentView.addSubview(label)
        
        button = UIButton(type: .custom)
        button.setTitle("点击", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(click), for: .touchUpInside)

//        contentView.addSubview(button)
        contentView.addSubview(enjoy)
    }
    
    @objc func click() {
        clickCallback?()
    }
    
    override func layoutSubviews() {
        label.sizeToFit()
        label.center = contentView.center
        button.sizeToFit()
        
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

        // Configure the view for the selected state
    }
    
    lazy var cake: Cake = Cake(frame: .zero)
    
    lazy var enjoy: Enjoy = {
        let enjoy = Enjoy(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        enjoy.backgroundColor = .black
        enjoy.action = { state in
            if state == .dislike {
                self.clickCallback?()
            } else {
                self.clickCallback?()
            }
        }
        return enjoy
    }()
}
