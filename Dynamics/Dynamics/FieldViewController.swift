//
//  FieldViewController.swift
//  Dynamics
//
//  Created by TSC on 2020/2/28.
//  Copyright © 2020 TSC. All rights reserved.
//

import UIKit

class FieldViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(ballView)
        
        dynamicAnimator.setValue(true, forKey: "debugEnabled")
        //step4、 UIDynamicAnimator添加所有的特性
        dynamicAnimator.addBehavior(gravifyFieldBehavior)
        dynamicAnimator.addBehavior(vortexFieldBehavior)
        //step3、 将每个特性关联到相应的视图上(addItem)
        gravifyFieldBehavior.addItem(ballView)
        vortexFieldBehavior.addItem(ballView)
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
    lazy var gravifyFieldBehavior: UIFieldBehavior = {
        let gravifyFieldBehavior = UIFieldBehavior.radialGravityField(position: view.center)
        gravifyFieldBehavior.region = UIRegion(size: view.bounds.size)
        gravifyFieldBehavior.position = view.center //region的中心点
        gravifyFieldBehavior.strength = 5  //这里的strength不宜过大，否则很容易重力大于漩涡的吸引力，而逃出漩涡，演示不成功
        gravifyFieldBehavior.falloff = 4.0 //falloff越大，作用区域越小
        gravifyFieldBehavior.minimumRadius = 50
        return gravifyFieldBehavior
    }()
    
    //step2、 初始化所有需要的行为(上述中的物理特性)
    lazy var vortexFieldBehavior: UIFieldBehavior = {
        let vortexFieldBehavior = UIFieldBehavior.vortexField()
        vortexFieldBehavior.region = UIRegion(radius: 200) //漩涡的区域不能太长，否则小球跑出屏幕外
        vortexFieldBehavior.strength = 0.005
        vortexFieldBehavior.position = view.center //region的中心点
        return vortexFieldBehavior
    }()
}
