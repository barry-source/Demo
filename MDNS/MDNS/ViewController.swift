//
//  ViewController.swift
//  MDNS
//
//  Created by 童世超 on 2024/7/1.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "disconnected"
        client.startBroadCasting()
        view.addSubview(dataView)
        dataView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
    }

    private lazy var client: BonjourClient = {
        let client = BonjourClient()
        client.delegate = self
        return client
    }()
    
    private lazy var dataView: DataView = {
        let view = DataView(firstText: "From Server", secondText: "To Server")
        view.toContentTextField.text = "123"
        view.sendCallback = { [weak self] text in
            guard let data = text.data(using: String.Encoding.utf8) else { return }
            self?.client.send(data)
        }
        return view
    }()
}

extension ViewController: BonjourClientDelegate {
    
    func onConnected(_ socket: GCDAsyncSocket) {
        print("connected")
        title = "connnected"
    }
    
    func onDisconnected() {
        print("disconnected")
        title = "disconnected"
    }
    
    func onHandleBody(_ body: NSString?) {
        guard let body = body as? String else { return }
        dataView.setText(body)
    }
    
}

