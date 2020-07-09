//
//  GravigyViewController.swift
//  Dynamics
//
//  Created by TSC on 2020/2/28.
//  Copyright © 2020 TSC. All rights reserved.
//

import UIKit

class GravigyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(ballView)
        
        //step3、 将每个特性关联到相应的视图上(addItem)
        gravityBehavior.addItem(ballView)
        //step4、 UIDynamicAnimator添加所有的特性
        dynamicAnimator.addBehavior(gravityBehavior)
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
    lazy var gravityBehavior: UIGravityBehavior = {
        let gravityBehavior = UIGravityBehavior()
//        gravityBehavior.gravityDirection = CGVector(dx: -1, dy: 1)
        //角度是按顺时针方向设置
//        gravityBehavior.angle = CGFloat(Double.pi / 4.0 * 3)
        gravityBehavior.action = {
            print(gravityBehavior.gravityDirection)
            print(gravityBehavior.angle)
        }
        return gravityBehavior
    }()

}
