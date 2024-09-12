//
//  Client.swift
//  MDNS
//
//  Created by 童世超 on 2024/7/1.
//

import UIKit

enum DataTag: Int {
    case header = 1
    case body = 2
}

protocol BonjourClientDelegate {
    func onConnected(_ socket: GCDAsyncSocket)
    func onDisconnected()
    func onHandleBody(_ body: NSString?)
}

class BonjourClient: NSObject {
    
    private var service: NetService?
    private var socket: GCDAsyncSocket?
    var delegate: BonjourClientDelegate?
    
    override init() {
        super.init()
    }
    
    func startBroadCasting() {
        socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        guard let socket = socket else { return }
        var error: NSError?
        do {
            // mDNS建立连接之后作为服务端监听端口0（系统自动分配端口）
            try socket.accept(onPort: 0)
            // 创建服务并发布
            service = NetService(domain: "local.", type: "_sraf-rc._tcp.", name: UIDevice.current.name + "@" + ("1c:2f:a2:f4:b2:94" + "\(socket.localPort)"), port: Int32(socket.localPort))
            service?.schedule(in: .current, forMode: .common)
            service?.delegate = self
            let dict = ["macAddr": ("1c:2f:a2:f4:b2:94" + "\(socket.localPort)").data(using: .utf8)!,
             "deviceName": "D003".data(using: .utf8)!,
             "protocolVersion": "0.1.0".data(using: .utf8)!,
             "os": "Linux".data(using: .utf8)!,
             "features": "rc,mouse,keyboard,touchpad".data(using: .utf8)!,
             "modelName": "mt5867_ww_1g_cvte_projector".data(using: .utf8)!,
             "osVersion": "4.19".data(using: .utf8)!
            ]
            let data = NetService.data(fromTXTRecord:dict)
           
            
            let isSucceed = service?.setTXTRecord(data) ?? false
            if isSucceed {
                service?.publish()
            } else {
                
            }
            
        } catch let error1 as NSError {
            error = error1
            print("Unable to create socket. Error \(String(describing: error))")
        }
    }
    
    func parseHeader(_ data: Data) -> UInt {
        var out: UInt = 0
        (data as NSData).getBytes(&out, length: MemoryLayout<UInt>.size)
        return out
    }
    
    func handleResponseBody(_ data: Data) -> NSString? {
        return NSString(data: data, encoding: String.Encoding.utf8.rawValue)
    }
    
    func send(_ data: Data) {
        var header = data.count
        let headerData = Data(bytes: &header, count: 4)
        socket?.write(headerData, withTimeout: -1.0, tag: DataTag.header.rawValue)
        socket?.write(data, withTimeout: -1.0, tag: DataTag.body.rawValue)
    }
    
}

extension BonjourClient: GCDAsyncSocketDelegate {
    
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        print("Did accept new socket")
        socket = newSocket
        socket?.readData(toLength: 4, withTimeout: -1.0, tag: 0)
        delegate?.onConnected(newSocket)
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("socket did disconnect: error \(String(describing: err))")
        if socket == socket {
            delegate?.onDisconnected()
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        print("did read data")
        
        if data.count == 4 {
            let d = data.reversed()
            let bodyLength: UInt = parseHeader(Data(d))
            sock.readData(toLength: bodyLength, withTimeout: -1, tag: DataTag.body.rawValue)
        } else {
            let body = handleResponseBody(data)
            delegate?.onHandleBody(body)
            sock.readData(toLength: 4, withTimeout: -1, tag: DataTag.header.rawValue)
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        print("did write data with tag: \(tag)")
    }
}

extension BonjourClient: NetServiceDelegate {
    
    func netServiceWillPublish(_ sender: NetService) {
        print("=========================================")
        print("\(#function)")
    }
    
    func netServiceDidPublish(_ sender: NetService) {
        print("=========================================")
        print("\(#function)")
        print("Bonjour service published. domain: \(sender.domain), type: \(sender.type), name: \(sender.name), port: \(sender.port)")
    }
    
    func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        print("=========================================")
        print("\(#function)")
        print("Unable to create socket. domain: \(sender.domain), type: \(sender.type), name: \(sender.name), port: \(sender.port), Error \(errorDict)")
    }
    
    func netServiceWillResolve(_ sender: NetService) {
        print("=========================================")
        print("\(#function)")
        print()
    }
    
    func netServiceDidStop(_ sender: NetService) {
        print("=========================================")
        print("\(#function)")
    }
    
    func netService(_ sender: NetService, didUpdateTXTRecord data: Data) {
        print("=========================================")
        print("\(#function)")
    }
    
    func netService(_ sender: NetService, didAcceptConnectionWith inputStream: InputStream, outputStream: OutputStream) {
        print("=========================================")
        print("\(#function)")
    }
    
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        
    }
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        
    }
}
