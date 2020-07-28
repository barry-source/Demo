

import UIKit

class ScreenShotAndCapture {
    
    // 录屏的视图
    public var capturedView: UIView?
    
    init(capturedView: UIView?) {
        self.capturedView = capturedView
    }

    // 开始
    public func start() {
        stop()
        NotificationCenter.default.addObserver(self, selector: #selector(screenShotEvent), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        if #available(iOS 11.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(screenCapEvent), name: UIScreen.capturedDidChangeNotification, object: nil)
        }
        setCoverView()
    }
    
    // 停止
    public func stop() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func screenShotEvent() {
        if #available(iOS 11.0, *) {
            if UIScreen.main.isCaptured {
                setCoverView()
            } else {
                print("录屏结束")
                coverView.removeFromSuperview()
            }
        }
    }
    
    // 屏幕截图
    @objc private func screenCapEvent() {
        print("屏幕截图")
    }
    
    private func setCoverView() {
        if #available(iOS 11.0, *) {
            if !UIScreen.main.isCaptured { return }
            if let capturedView = capturedView {
                capturedView.addSubview(coverView)
                coverView.frame = capturedView.bounds
                blurView.frame = coverView.bounds
            }
            print("开始录屏")
        }
        
    }
    
    private lazy var coverView: UIView = {
        let view = UIView()
        view.layer.zPosition = -100
        view.isUserInteractionEnabled = false
        view.addSubview(blurView)
        return view
    }()
    
    private var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }()
}
