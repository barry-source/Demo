//
//  ViewController.swift
//  Enjoy
//
//  Created by TSC on 2020/3/2.
//  Copyright © 2020 TSC. All rights reserved.
//

import UIKit

//替换图片演示效果
//icon_home_like_before ----BirthdayUnlikeButton
//icon_home_like_after--BirthdayLikeForVideo_16

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(button)
    }

    @objc func buttonDidClick() {
        navigationController?.pushViewController(TestViewController(), animated: true)
    }
    
    lazy var button: UIButton = {
        let enjoy = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        enjoy.setTitle("测试", for: UIControl.State.normal)
        enjoy.setTitleColor(.blue, for: .normal)
        enjoy.addTarget(self, action: #selector(buttonDidClick), for: .touchUpInside)
        enjoy.center = view.center
        return enjoy
    }()
}

