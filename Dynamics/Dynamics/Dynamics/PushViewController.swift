//
//  PushViewController.swift
//  Dynamics
//
//  Created by TSC on 2020/2/28.
//  Copyright © 2020 TSC. All rights reserved.
//

import UIKit

class PushViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(ballView)
        //step4、 UIDynamicAnimator添加所有的特性
        [pushBehavior, collisionBehavior, pushBehavior].forEach(dynamicAnimator.addBehavior)
        //step3、 将每个特性关联到相应的视图上(addItem)
        collisionBehavior.addItem(ballView)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

    //step1、 创建一个UIDynamicAnimator用于为所有Dynamic Items提供动画效果的环境
    lazy var dynamicAnimator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self.view)

    lazy var ballView: BallView = {
        let ballView = BallView(frame: CGRect(x: 90, y: 100, width: 50, height: 50))
        ballView.layer.cornerRadius = 25
        ballView.layer.masksToBounds = true
        return ballView
    }()

    lazy var collisionBehavior: UICollisionBehavior = {
        let collisionBehavior = UICollisionBehavior()
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionMode = .boundaries
        return collisionBehavior
    }()

    //step2、 初始化所有需要的行为(上述中的物理特性)
    lazy var pushBehavior: UIPushBehavior = {
        //step3、 将每个特性关联到相应的视图上(addItem) -- 这里在初始化的时候将对应的视图添加  UIPushBehavior.Mode.continuous
        let pushBehavior = UIPushBehavior(items: [ballView], mode: UIPushBehavior.Mode.instantaneous)
        //设置角度 和 力量大小
        pushBehavior.setAngle(CGFloat(Double.pi / 4), magnitude: 10)
        pushBehavior.angle = CGFloat(Double.pi / 4 * 3)
        pushBehavior.magnitude = 10
        pushBehavior.active = true
        return pushBehavior
    }()

    //step2、 初始化所有需要的行为(上述中的物理特性)
    lazy var gravityBehavior: UIGravityBehavior = {
        //step3、 将每个特性关联到相应的视图上(addItem) -- 这里在初始化的时候将对应的视图添加
        let gravityBehavior = UIGravityBehavior(items: [ballView])
        return gravityBehavior
    }()
}
