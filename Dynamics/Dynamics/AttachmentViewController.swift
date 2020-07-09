//
//  AttachmentViewController.swift
//  Dynamics
//
//  Created by TSC on 2020/2/28.
//  Copyright © 2020 TSC. All rights reserved.
//

import UIKit

class AttachmentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(lineView)
        view.addSubview(ballView)
        lineView.frame = view.bounds
        //step4、 UIDynamicAnimator添加所有的特性
        dynamicAnimator.addBehavior(gravityBehavior)
        dynamicAnimator.addBehavior(attatchBehavior)
        //step3、 将每个特性关联到相应的视图上(addItem)
        gravityBehavior.addItem(ballView)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let allTouches = event?.allTouches else { return }
        guard let touch = allTouches.first else { return }
        let point = touch.location(in: touch.view)
        
        attatchBehavior.action = { [weak self] in
            guard let self = self else {
                return
            }
            self.lineView.endPoint = self.view.convert(CGPoint(x: 25, y: 25), from: self.ballView)
            self.lineView.startPoint = point
        }
    }

    //step1、 创建一个UIDynamicAnimator用于为所有Dynamic Items提供动画效果的环境
    lazy var dynamicAnimator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self.view)

    lazy var ballView: BallView = {
        let ballView = BallView(frame: CGRect(x: 90, y: 100, width: 50, height: 50))
        ballView.layer.cornerRadius = 25
        ballView.layer.masksToBounds = true
        return ballView
    }()

    lazy var lineView: LineView = {
        let lineView = LineView(frame: CGRect(x: 90, y: 100, width: 50, height: 50))
        lineView.backgroundColor = .white
        return lineView
    }()

    //step2、 初始化所有需要的行为(上述中的物理特性)
    lazy var attatchBehavior: UIAttachmentBehavior = {
        //step3、 将每个特性关联到相应的视图上(addItem) -- 这里在初始化的时候将对应的视图添加
        let attatchBehavior = UIAttachmentBehavior(item: ballView, attachedToAnchor: CGPoint(x: UIScreen.main.bounds.size.width / 2.0, y: UIScreen.main.bounds.size.height / 2.0))
        attatchBehavior.length = 180;
    //        attatchBehavior.damping = 1
    //        attatchBehavior.frequency = 0
        attatchBehavior.action = { [weak self] in
            guard let self = self else {
                return
            }
            self.lineView.endPoint = self.view.convert(CGPoint(x: 25, y: 25), from: self.ballView)
            self.lineView.startPoint = CGPoint(x: 50, y: 100)
        }
        return attatchBehavior
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

}
