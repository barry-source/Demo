//
//  CollisionViewController.swift
//  Dynamics
//
//  Created by TSC on 2020/2/28.
//  Copyright © 2020 TSC. All rights reserved.
//

import UIKit

class CollisionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(ballView)
        
        //step4、 UIDynamicAnimator添加所有的特性
        [gravityBehavior, collisionBehavior, dynamicItemBehavior].forEach(dynamicAnimator.addBehavior)
        //step3、 将每个特性关联到相应的视图上(addItem)
        gravityBehavior.addItem(ballView)
        collisionBehavior.addItem(ballView)
//        dynamicItemBehavior.addItem(ballView) //是否开启dynamicItemBehavior   (自行取消注释)
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
    lazy var collisionBehavior: UICollisionBehavior = {
        let collisionBehavior = UICollisionBehavior()
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionMode = .boundaries
        return collisionBehavior
    }()

    //step2、 初始化所有需要的行为(上述中的物理特性)
    lazy var gravityBehavior: UIGravityBehavior = {
        let gravityBehavior = UIGravityBehavior()
        gravityBehavior.action = {
            print(gravityBehavior.gravityDirection)
            print(gravityBehavior.angle)
        }
        return gravityBehavior
    }()
    
    //step2、 初始化所有需要的行为(上述中的物理特性)
    lazy var dynamicItemBehavior: UIDynamicItemBehavior = {
        let dynamicItemBehavior = UIDynamicItemBehavior()
        dynamicItemBehavior.density = 5
        dynamicItemBehavior.elasticity = 1
        return dynamicItemBehavior
    }()
}
