//
//  CircleView.swift
//  Enjoy
//
//  Created by TSC on 2020/3/2.
//  Copyright © 2020 TSC. All rights reserved.
//

import UIKit

class CircleView: UIControl {

    var callback: (() -> Void)?
    var endCallback: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func beginAnimation() {
        if let result = layer.sublayers?.contains(shapeLayer), result { return }
        group.animations = [basicAnimation]
        shapeLayer.add(group, forKey: "shapeLayer")
        layer.addSublayer(shapeLayer)
    }
    
    lazy var basicAnimation: CABasicAnimation = {
        let basicAnimation = CABasicAnimation(keyPath: "transform.scale")
        basicAnimation.fromValue = NSNumber(value: 0)
        basicAnimation.toValue = NSNumber(value: 1)
        basicAnimation.duration = 0.23
        return basicAnimation
    }()
    
    lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 2
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.transform = CATransform3DMakeScale(1, 1, 0)
        let outerPath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: 10, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        shapeLayer.path = outerPath.cgPath
        return shapeLayer
    }()
    
    lazy var group: CAAnimationGroup = {
        let group = CAAnimationGroup()
        group.isRemovedOnCompletion = false
        group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        group.fillMode = CAMediaTimingFillMode.forwards
        group.duration = 0.2
        group.delegate = self
        return group
    }()
    
    lazy var layers: [CAShapeLayer] = []
}

extension CircleView: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim is CAAnimationGroup { //添加放射线动画
            layers.removeAll()
            for i in 0..<5 {
                let shapeLayer = CAShapeLayer()
                shapeLayer.lineWidth = 1
                shapeLayer.strokeColor = UIColor.red.cgColor
                shapeLayer.fillColor = UIColor.red.cgColor
                shapeLayer.transform = CATransform3DMakeRotation(CGFloat(Double.pi / 4 * Double(i) + Double.pi / 2 + 0.05), 0.0, 0.0, 1.0);
                
                let outerPath = UIBezierPath(rect: CGRect(x: 0, y: 14, width: 1, height: 5))
                shapeLayer.path = outerPath.cgPath
                layer.addSublayer(shapeLayer)
                layers.append(shapeLayer)
            }
            //处理消失动画
            let disapperPath = UIBezierPath(rect: CGRect(x: 0, y: 18, width: 0, height: 0))
            layers.enumerated().forEach { (e, shapeLayer) in
                let basicAnimation = CABasicAnimation(keyPath: "path")
                basicAnimation.fromValue = shapeLayer.path
                basicAnimation.toValue = disapperPath.cgPath
                basicAnimation.duration = 0.2
                basicAnimation.delegate = self
                basicAnimation.isRemovedOnCompletion = false //这里不能动画完成之后移除，否则代理方法回调时不能通过animation(forKey: "\(e)")获取动画
                shapeLayer.add(basicAnimation, forKey: "\(e)")
            }
            shapeLayer.removeFromSuperlayer()
            callback?()
        } else if anim is CABasicAnimation { //移除放射线
            let anim = anim as! CABasicAnimation
            layers.enumerated().forEach { (e, shapeLayer) in
                if let animation = shapeLayer.animation(forKey: "\(e)"), anim == animation {
                    shapeLayer.removeFromSuperlayer()
                }
            }
            if self.layer.sublayers == nil {
                endCallback?()
                layers.removeAll()
            }
            return
        }
    }
}
