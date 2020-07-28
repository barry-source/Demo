//
//  ViewController.swift
//  CakeAnimation
//
//  Created by tongshichao on 2020/3/3.
//  Copyright © 2020 tongshichao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.addSubview(cake)
        view.addSubview(tableview)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        cake.start()
    }
    
    lazy var basicAnimation: CABasicAnimation = {
        let basicAnimation = CABasicAnimation(keyPath: "position")
        basicAnimation.fromValue = NSNumber(value: 0)
        basicAnimation.toValue = NSNumber(value: 1)
        basicAnimation.duration = 0.23
        basicAnimation.isRemovedOnCompletion = false
        return basicAnimation
    }()
    
    public func randomFloatNumber(lower: Float = 0,upper: Float = 100) -> Float {
        return (Float(arc4random()) / Float(UInt32.max)) * (upper - lower) + lower
    }

    lazy var cake: Cake = Cake(frame: self.view.bounds)

    lazy var tableview: UITableView = {
        let tableview = UITableView(frame: view.bounds, style: .plain)
        tableview.register(TestTableViewCell.self, forCellReuseIdentifier: "test")
        tableview.dataSource = self
        tableview.rowHeight = 80
        return tableview
    }()
    
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "test") as! TestTableViewCell
        cell.clickCallback = { [weak self] in
            guard let self = self else { return }
            if self.cake.isAnimating {
                self.cake.stop()
            } else {
                let window =  UIApplication.shared.windows[0]
                if !window.subviews.contains(self.cake) {
                    window.addSubview(self.cake)
                    self.cake.frame = window.bounds
                    self.cake.start()
                } else {
                    self.cake.frame = window.bounds
                    self.cake.start()
                }
            }
        }
        return cell
    }
}

