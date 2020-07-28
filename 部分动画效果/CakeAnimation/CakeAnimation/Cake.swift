//
//  Cake.swift
//  CakeAnimation
//
//  Created by tongshichao on 2020/3/3.
//  Copyright © 2020 tongshichao. All rights reserved.
//

import UIKit
enum SpeedDirection {
    case vertical
    case left
    case right
}

struct DataSource {
    let permitArray = [1, 2, 4, 5, 6, 7, 8, 9, 10, 12, 13, 15, 17, 18, 21, 22, 35] //创建cake的时间点,时间间隔是定时器的定时时间
    //17个cake 1,2,14,15,16,17前二后四竖直  3水平右微调 4、5水平左微调 7竖直， 6 9，水平快速左微调 8 10水平右微调 11竖直 12水平右微调 13水平左微调
    let directionArray: [SpeedDirection] = [.vertical, .vertical, .right, .left, .left, .left, .vertical, .right,
                                            .left, .right, .vertical, .right, .left, .vertical, .vertical, .vertical,
                                            .vertical]
    
    func horizontalMovement(index: Int) -> Bool {
        if directionArray[index] == .vertical {
            return false
        }
        return true
    }
}

class Cake: UIView, CAAnimationDelegate {

    private var count: Int = 0 //总共17个
    private var totalCount: Int = 0 //用来总计时
    private(set) var isAnimating: Bool = false
    private var viewArray:[UIImageView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if !isAnimating { return }
        if count >= 17 { return }
        totalCount += 1
        if !canCreateCakeBy(count: totalCount) { return }
        
        func createBasicAnimation(with fromValue: Any?, toValue: Any?, duration: CFTimeInterval) -> CABasicAnimation {
            let basicAnimation = CABasicAnimation()
            basicAnimation.keyPath = "position"
            basicAnimation.fromValue = fromValue
            basicAnimation.toValue = toValue
            basicAnimation.duration = duration
            basicAnimation.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.linear)
            basicAnimation.isRemovedOnCompletion = false
            basicAnimation.delegate = self
            return basicAnimation
        }
        
        let width: CGFloat = 50
        let speed = fetchSpeedBy(count: totalCount)
        let startY: CGFloat = 0
        let startX: CGFloat = CGFloat(arc4random()).truncatingRemainder(dividingBy: UIScreen.main.bounds.width)
        var endX: CGFloat = startX
        if dataSource.horizontalMovement(index: count) {
            endX = CGFloat(arc4random()).truncatingRemainder(dividingBy: UIScreen.main.bounds.width)
        }
        let imageView = UIImageView(image: UIImage(named: "BirthdayLikeButtonForVideo"))
        imageView.frame = CGRect(x: startX, y: startY, width: width, height: width)
        viewArray.append(imageView)
        addSubview(imageView)
        //添加动画
        let basicAnimation = createBasicAnimation(with: imageView.frame.origin, toValue: CGPoint(x: endX, y: UIScreen.main.bounds.height), duration: speed)
        imageView.layer.add(basicAnimation, forKey: "\(count)")
        count += 1
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        viewArray.enumerated().forEach { (index, imageView) in
            if let animation = imageView.layer.animation(forKey: "\(index)"), anim == animation {
                imageView.removeFromSuperview()
            }
        }
        if subviews.count == 0 {
            isAnimating = false
            removeFromSuperview()
        }

    }
    
    @objc private func timerAction() {
        if count >= 17 {
            timer.invalidate()
            totalCount = 0
        }
        setNeedsDisplay()
    }

    private func canCreateCakeBy(count: Int) -> Bool {
        print(count)
        return dataSource.permitArray.contains(count)
    }
    
    private func fetchSpeedBy(count: Int) -> Double {
        if count == 5 {
            return 8
        }
        return 7
    }
    
    func start() {
        if isAnimating { return }
        viewArray.removeAll()
        count = 0
        totalCount = 0
        subviews.forEach { $0.removeFromSuperview() }
        isAnimating = true
        if !timer.isValid {
            timer = Timer(timeInterval: 0.2, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
        RunLoop.main.add(timer, forMode: .common)
    }
    
    func stop() {
        if !isAnimating { return }
        timer.invalidate()
        viewArray.removeAll()
        count = 0
        totalCount = 0
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    private lazy var dataSource = DataSource()
    
    private lazy var timer = Timer(timeInterval: 0.2, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)

}
