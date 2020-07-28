//
//  SnapViewController.swift
//  Dynamics
//
//  Created by TSC on 2020/2/28.
//  Copyright © 2020 TSC. All rights reserved.
//

import UIKit

class SnapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(ballView)
        //step4、 UIDynamicAnimator添加所有的特性
        dynamicAnimator.addBehavior(snapBehavior)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let allTouches = event?.allTouches else { return }
        guard let touch = allTouches.first else { return }
        let point = touch.location(in: touch.view)
        snapBehavior.snapPoint = point
    }

    //step1、 创建一个UIDynamicAnimator用于为所有Dynamic Items提供动画效果的环境
    lazy var dynamicAnimator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self.view)

    lazy var ballView: BallView = {
        let ballView = BallView(frame: CGRect(x: 90, y: 100, width: 50, height: 50))
        ballView.layer.cornerRadius = 25
        ballView.layer.masksToBounds = true
        return ballView
    }()

    //step2、 初始化所有需要的行为(上述中的物理特性)
    lazy var snapBehavior: UISnapBehavior = {
        //step3、 将每个特性关联到相应的视图上(addItem) -- 这里在初始化的时候将对应的视图添加
        let snapBehavior = UISnapBehavior(item: ballView, snapTo: ballView.center)
//        snapBehavior.damping = 0
        return snapBehavior
    }()

    
}
