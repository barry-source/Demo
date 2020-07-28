//
//  Enjoy.swift
//  Enjoy
//
//  Created by TSC on 2020/3/2.
//  Copyright © 2020 TSC. All rights reserved.
//

import UIKit
enum ImageState {
    case like
    case dislike
}

class Enjoy: UIControl, UIGestureRecognizerDelegate {

    var action: ((ImageState) -> Void)? //
    
    public var imageState: ImageState = .dislike {
        didSet {
            if imageState == .like {
                isUserInteractionEnabled = false
                imageView.image = UIImage(named: "BirthdayUnlikeButton")
                circleView.isHidden = false
                //step1:处理imageView的缩小
                shrink()
                //step2处理圆环的放大
                //step3处理放射性线
                //step4显示imageView喜欢状态并放大 放射性线缩小
                //step5 喜欢缩小再放大到正常状态
            } else {
                imageView.image = UIImage(named: "BirthdayUnlikeButton")
                imageView.tintColor = .red
                self.action?(.dislike)
            }
        } //didSet
    }
    
    //圆形+放射性动画
    private func circleViewAnimation() {
        circleView.frame.origin = self.imageView.center
        circleView.beginAnimation()
    }
    
    //imageview 缩小
    private func shrink() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self = self else { return }
            self.imageView.bounds.size = CGSize(width: 1, height: 1)
        }) { (result) in
            self.circleViewAnimation()
        }
    }
    
    //imageview 恢复原状
    private func resume() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.01, initialSpringVelocity: 5, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.imageView.bounds.size = CGSize(width: 40, height: 40)
        }) { (result) in
            self.action?(.like)
            self.isUserInteractionEnabled = true
        }
    }
    
    @objc func tapGestureDidClick() {
        if imageState == .like {
            imageState = .dislike
        } else {
            imageState = .like
        }
    }
    
    @objc func longGestureDidClick(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            print("began")
            imageView.tintColor = .green
            imageView.image = UIImage(named: "BirthdayUnlikeButton")
        } else if gesture.state == .changed { //是否处理移动范围待商榷
            print("changed")
            imageView.tintColor = .green
            imageView.image = UIImage(named: "BirthdayUnlikeButton")
        } else if gesture.state == .ended {
            //处理触摸点是否在范围内
            let location = gesture.location(in: self)
            if self.bounds.contains(location) {
                if imageState == .like {
                    imageState = .dislike
                } else {
                    imageState = .like
                }
            } else {
                if imageState == .like {
                    imageView.image = UIImage(named: "BirthdayLikeForVideo_16")
                } else {
                    imageView.image = UIImage(named: "BirthdayUnlikeButton")
                    imageView.tintColor = .red
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [imageView, circleView].forEach(addSubview)
        imageView.center = center
        imageView.bounds.size = CGSize(width: 40, height: 40)
        [tapGesture, longPressGesture].forEach(addGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BirthdayUnlikeButton")
        imageView.tintColor = .red
        return imageView
    }()
    
    lazy var circleView: CircleView = {
        let circleView = CircleView(frame: CGRect(x: 150, y: 150, width: 210, height: 200))
        circleView.callback = { [weak self] in
            guard let self = self else { return }
            self.imageView.image = UIImage(named: "BirthdayLikeForVideo_16")
            self.imageView.bounds.size = CGSize(width: 20, height: 20)
            UIView.animate(withDuration: 0.08, animations: {
                self.imageView.bounds.size = CGSize(width: 45, height: 45)
            }) { (result) in
                self.resume()
            }
        }
        circleView.endCallback = {
            circleView.isHidden = true
        }
        return circleView
    }()

    lazy var longPressGesture: UILongPressGestureRecognizer = {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longGestureDidClick))
        longPressGesture.minimumPressDuration = 0.1
        return longPressGesture
    }()
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureDidClick))
        tapGesture.delegate = self
        return tapGesture
    }()
    
    deinit {
        print("deinit")
    }
}
