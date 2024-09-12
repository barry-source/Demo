//
//  BonjourServer.swift
//  MDNS
//
//  Created by 童世超 on 2024/7/2.
//

import UIKit

protocol BonjourBrowserDelegate {
    func onConnected()
    func onDisconnected()
    func onHandleBody(_ body: NSString?)
    
    func onWillSearch(_ browser: BonjourBrowser)
    func onDidStopSearch(_ browser: BonjourBrowser)
    func onDidNotSearch(_ browser: BonjourBrowser, errorDict: [String: NSNumber])
    func onDidFindDomain(_ browser: BonjourBrowser, domainString: String)
    func onDidFindService(_ browser: BonjourBrowser, service: NetService)
    func onDidRemoveDomain(_ browser: BonjourBrowser, domainString: String)
    func onDidRemove(_ browser: BonjourBrowser, service: NetService)
    
    func onDidNotResolveService(_ browser: BonjourBrowser, service: NetService, errorDict: [String: NSNumber])
    func onServicesChanged(_ browser: BonjourBrowser)
}

final class BonjourBrowser: NSObject {
    private var timeout: TimeInterval { 15 }

    private var headerLength: Int { 14 }
    
    private var selectedSocket: GCDAsyncSocket? {
        guard let connectedService = connectedService, let sock = sockets[connectedService.name] else { return nil }
        return sock
    }
    
    private var serviceBrowser: NetServiceBrowser?
    private var connectedService: NetService?
    private var sockets: [String: GCDAsyncSocket] = [:]
    private(set) var devices: [NetService] = []
    var delegate: BonjourBrowserDelegate?
    var connectedIP: String?
    
    var connectedPort: Int { connectedService?.port ?? -1 }

    override init() {
        super.init()
    }
    
    // MARK: - Public
    
    func startBrowse() {
        if !devices.isEmpty {
            devices.removeAll(keepingCapacity: true)
        }
        serviceBrowser = NetServiceBrowser()
        serviceBrowser?.stop()
        serviceBrowser?.delegate = self
        serviceBrowser?.searchForServices(ofType: "_sraf-rc._tcp", inDomain: "local.")
    }
    
    func stopBrowsing() {
        if serviceBrowser != nil {
            serviceBrowser?.stop()
            serviceBrowser?.delegate = nil
            serviceBrowser = nil
        }
    }
    
    func sendCmd(cmd: Command) {
        guard let socket = selectedSocket else { return }
        EventHelper.shared.sendEvent(command: cmd, socket: socket)
    }

    func connectTo(_ service: NetService) {
        service.delegate = self
        service.stop()
        service.startMonitoring()
        service.resolve(withTimeout: timeout)
    }
    
    // MARK: - Private
    
    private func parseHeader(_ data: Data) -> UInt {
        var out: UInt = 0
        (data as NSData).getBytes(&out, length: headerLength)
        return out
    }
    
    private func handleResponseBody(_ data: Data) {
        if let message = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
            delegate?.onHandleBody(message)
        }
    }

    private func fetchFirstIPV4(_ addresses: [Data]) -> (Int, String) {
        for (i, data) in addresses.enumerated() {
            let ip = data.convertToIP()
            if data.isIPV4 {
                return (i, ip)
            }
        }
        return (-1, "")
    }
    
    private func connectToService(_ service: NetService) -> Bool {
        guard let addresses = service.addresses else { return false }
        var socket = sockets[service.name]
        if socket?.isConnected == true { return true }
        socket = GCDAsyncSocket(delegate: self, delegateQueue: .main)
        guard let socket = socket else { return false }
        var connected = false
        let result = fetchFirstIPV4(addresses)
        if result.0 != -1 {
            connectedIP = result.1
        }
        let address: Data = addresses[result.0]
        let isConnected: ()? = try? socket.connect(toAddress: address)
        if isConnected != nil {
            sockets.updateValue(socket, forKey: service.name)
            connectedService = service
            connected = true
        }
        return connected
    }
}

extension BonjourBrowser: NetServiceBrowserDelegate {
    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        delegate?.onWillSearch(self)
    }
    
    func netServiceBrowser(_ aNetServiceBrowser: NetServiceBrowser, didFind aNetService: NetService, moreComing: Bool) {
        print("===================did find service======================")
        printService(aNetService: aNetService)
        delegate?.onDidFindService(self, service: aNetService)
        devices.append(aNetService)
        if !moreComing {
            delegate?.onServicesChanged(self)
        }
    }
    
    func netServiceBrowser(_ aNetServiceBrowser: NetServiceBrowser, didRemove aNetService: NetService, moreComing: Bool) {
        delegate?.onDidRemove(self, service: aNetService)
        devices.removeAll { $0 == aNetService }
        if !moreComing {
            delegate?.onServicesChanged(self)
        }
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFindDomain domainString: String, moreComing: Bool) {
        delegate?.onDidFindDomain(self, domainString: domainString)
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemoveDomain domainString: String, moreComing: Bool) {
        delegate?.onDidRemoveDomain(self, domainString: domainString)
    }
    
    func netServiceBrowserDidStopSearch(_ aNetServiceBrowser: NetServiceBrowser) {
        delegate?.onDidStopSearch(self)
    }
    
    func netServiceBrowser(_ aNetServiceBrowser: NetServiceBrowser, didNotSearch errorDict: [String: NSNumber]) {
        delegate?.onDidNotSearch(self, errorDict: errorDict)
    }
    
    func printService(aNetService: NetService) {
        print("find a device: \(aNetService.name), addresses: \(String(describing: aNetService.addresses))")
        print("domain   =====> \(aNetService.domain)")
        print("hostname =====> \(aNetService.hostName ?? "unknown")")
        print("name     =====> \(aNetService.name)")
        print("port     =====> \(aNetService.port)")
        print("txt data =====> \(String(describing: aNetService.txtRecordData))")
        
        guard let ipAddresses = aNetService.addresses else { return }
        guard let data = aNetService.txtRecordData() else { return }
        let dict = NetService.dictionary(fromTXTRecord: data)
        print("txt dict ====> \(dict)")
        print("txt dict111 ====> \(dict["deviceName"])")
//        String(data: dict["deviceName"]!, encoding: .utf8)
        
        for data in ipAddresses {
            let ipStr = data.convertToIP()
            if data.isIPV4 {
                print("A 记录: \(ipStr)")
            } else if data.isIPV6 {
                print("AAAA 记录: \(ipStr)")
            } else {
                print("valid ip: \(ipStr)")
            }
        }
    }
}

extension BonjourBrowser: NetServiceDelegate {
    func netServiceDidResolveAddress(_ sender: NetService) {
        print("===================did resolve address======================")
        printService(aNetService: sender)
        if connectToService(sender) {
            print("connected to \(sender.name)")
            delegate?.onServicesChanged(self)
        }
    }
    
    func netService(_ sender: NetService, didNotResolve errorDict: [String: NSNumber]) {
        delegate?.onDidNotResolveService(self, service: sender, errorDict: errorDict)
    }
}

extension BonjourBrowser: GCDAsyncSocketDelegate {
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        sock.readData(withTimeout: -1, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print("socket connected to host \(String(describing: host)), on port \(port)")
        UIApplication.shared.windows.first?.makeToast("socket connected to host \(String(describing: host)), on port \(port)")
        sock.readData(withTimeout: -1, tag: 0)
//        sock.readData(toLength: UInt(MemoryLayout<UInt64>.size), withTimeout: -1.0, tag: 0)
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("socket did disconnect \(String(describing: sock)), error: \(String(describing: err?._userInfo))")
        UIApplication.shared.windows.first?.makeToast("socket did disconnect \(String(describing: sock)), error: \(String(describing: err?._userInfo))")
        if let connectedService = connectedService {
            sockets[connectedService.name] = nil
        }
        connectedService?.stop()
        connectedService = nil
        UIApplication.shared.windows.first?.makeToast("断开连接")
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        print("socket did read data. tag: \(tag)")
        
        if selectedSocket == sock {
            if data.count == MemoryLayout<UInt>.size {
                let bodyLength: UInt = parseHeader(data)
                sock.readData(toLength: bodyLength, withTimeout: -1, tag: DataTag.body.rawValue)
            } else {
                handleResponseBody(data)
                sock.readData(toLength: UInt(MemoryLayout<UInt>.size), withTimeout: -1, tag: DataTag.header.rawValue)
            }
        }
    }
    
    func socketDidCloseReadStream(_ sock: GCDAsyncSocket) {
        print("socket did close read stream")
    }
}

extension BonjourBrowserDelegate {
    func onWillSearch(_ browser: BonjourBrowser) {
        print("\(#function)")
    }
    
    func onDidStopSearch(_ browser: BonjourBrowser) {
        print("\(#function)")
    }
    
    func onDidNotSearch(_ browser: BonjourBrowser, errorDict: [String: NSNumber]) {
        print("\(#function)")
    }
    
    func onDidFindDomain(_ browser: BonjourBrowser, domainString: String) {
        print("\(#function)")
    }
    
    func onDidFindService(_ browser: BonjourBrowser, service: NetService) {
        print("\(#function)")
    }
    
    func onDidRemoveDomain(_ browser: BonjourBrowser, domainString: String) {
        print("\(#function)")
    }
    
    func onDidRemove(_ browser: BonjourBrowser, service: NetService) {
        print("\(#function)")
    }
    
    func onDidNotResolveService(_ browser: BonjourBrowser, service: NetService, errorDict: [String: NSNumber]) {
        print("\(#function)")
    }
}

fileprivate extension Data {
    var isIPV4: Bool {
        let ip = convertToIP()
        let base = "(\\d|[1-9]\\d|1\\d\\d|2[0-4]\\d|25[0-5])"
        let regex = base + "(\\." + base + "){3}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: ip)
    }
    
    var isIPV6: Bool {
        let ip = convertToIP()
        let base = "([\\da-fA-F]{1,4})"
        let regex = base + "(:" + base + "){7}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: ip)
    }
    
    func convertToIP() -> String {
        let dataIn = self as NSData
        var storage = sockaddr_storage()
        dataIn.getBytes(&storage, length: MemoryLayout<sockaddr_storage>.size)
        if Int32(storage.ss_family) == AF_INET {
            let addr4 = withUnsafePointer(to: &storage) {
                $0.withMemoryRebound(to: sockaddr_in.self, capacity: 1) {
                    $0.pointee
                }
            }
            let ipString = String(cString: inet_ntoa(addr4.sin_addr), encoding: .ascii) ?? ""
            return ipString
        } else if Int32(storage.ss_family) == AF_INET6 {
            var addr = sockaddr_in6()
            memcpy(&addr, &storage, MemoryLayout<sockaddr_in6>.size)
            var ipBuffer = [CChar](repeating: 0, count: Int(INET6_ADDRSTRLEN))
            inet_ntop(AF_INET6, &addr.sin6_addr, &ipBuffer, socklen_t(INET6_ADDRSTRLEN))
            let ip = String(cString: ipBuffer)
            return ip
        }
        return ""
    }
}
