//
//  LineView.swift
//  Dynamics
//
//  Created by TSC on 2020/2/28.
//  Copyright © 2020 TSC. All rights reserved.
//

import UIKit

class LineView: UIView {

    var startPoint: CGPoint = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    var endPoint: CGPoint = .zero{
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        path.stroke()
    }

}
