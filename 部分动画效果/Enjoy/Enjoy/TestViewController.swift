//
//  TestViewController.swift
//  Enjoy
//
//  Created by TSC on 2020/3/3.
//  Copyright © 2020 TSC. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(enjoy)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if enjoy.state == .like {
//             enjoy.state = .dislike
//         } else {
//             enjoy.state = .like
//         }
//     }
    
    lazy var enjoy: Enjoy = {
        let enjoy = Enjoy(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        enjoy.backgroundColor = .black
        enjoy.center = view.center
        enjoy.action = { state in
            if state == .dislike {
                print("dislike")
            } else {
                print("like")
            }
        }
        return enjoy
    }()

}
