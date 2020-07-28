//
//  TestController.swift
//  ScreenShotAndCapture
//
//  Created by TSC on 2020/7/28.
//  Copyright © 2020 TSC. All rights reserved.
//

import UIKit

class TestController: UIViewController {

    private var count: UInt = 0
    private var timer: Timer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(timeLabel)
        timeLabel.center = view.center
        timeLabel.bounds.size = CGSize(width: 100, height: 100)
        view.backgroundColor = .white
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (timer) in
            guard let self = self else { return }
            self.count = self.count + 1
            self.timeLabel.text = "\(self.count)"
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenCapture.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        screenCapture.stop()
        timer?.invalidate()
    }
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .orange
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
        label.backgroundColor = .darkGray
        label.text = "0"
        return label
    }()
    
    private lazy var screenCapture: ScreenShotAndCapture = ScreenShotAndCapture(capturedView: timeLabel)
}
