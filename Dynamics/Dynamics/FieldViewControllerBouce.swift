//
//  FieldViewControllerBouce.swift
//  Dynamics
//
//  Created by TSC on 2020/2/28.
//  Copyright © 2020 TSC. All rights reserved.
//

import UIKit

class FieldViewControllerBouce: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(ballView)
        
        dynamicAnimator.setValue(true, forKey: "debugEnabled")
        //step4、 UIDynamicAnimator添加所有的特性
        dynamicAnimator.addBehavior(gravifyFieldBehavior)
        //step3、 将每个特性关联到相应的视图上(addItem)
        gravifyFieldBehavior.addItem(ballView)
    }

    //step1、 创建一个UIDynamicAnimator用于为所有Dynamic Items提供动画效果的环境
    lazy var dynamicAnimator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self.view)

    lazy var ballView: BallView = {
        let ballView = BallView(frame: CGRect(x: 90, y: 300, width: 50, height: 50))
        ballView.layer.cornerRadius = 25
        ballView.layer.masksToBounds = true
        return ballView
    }()

    //step2、 初始化所有需要的行为(上述中的物理特性)
    lazy var gravifyFieldBehavior: UIFieldBehavior = {
        let gravifyFieldBehavior = UIFieldBehavior.springField()
        gravifyFieldBehavior.position = view.center //region的中心点
        gravifyFieldBehavior.region = UIRegion(size: view.bounds.size)
        gravifyFieldBehavior.strength = 1.5 // 1.5
        gravifyFieldBehavior.falloff = 1.0
        gravifyFieldBehavior.minimumRadius = 150
        gravifyFieldBehavior.direction = CGVector(dx: 0, dy: -1)
        return gravifyFieldBehavior
    }()

    //step2、 初始化所有需要的行为(上述中的物理特性)
    lazy var dynamicItemBehavior: UIDynamicItemBehavior = {
        let dynamicItemBehavior = UIDynamicItemBehavior()
        dynamicItemBehavior.addItem(ballView)
        dynamicItemBehavior.density = 0.5
        return dynamicItemBehavior
    }()

}
