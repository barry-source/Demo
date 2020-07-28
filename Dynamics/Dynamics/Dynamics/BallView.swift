//
//  BallView.swift
//  Dynamics
//
//  Created by TSC on 2020/2/28.
//  Copyright © 2020 TSC. All rights reserved.
//

import UIKit

class BallView: UIImageView {

    override var collisionBoundsType: UIDynamicItemCollisionBoundsType { return .ellipse }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        image = UIImage(named: "ball")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
