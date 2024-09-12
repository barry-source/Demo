//
//  ServerController.swift
//  MDNS
//
//  Created by 童世超 on 2024/7/2.
//

import UIKit
import SnapKit
import Toast_Swift
import Network

class ServerController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Server"
//        if #available(iOS 14.0, *) {
//            LocalNetworkAuth().checkAccessState { granted in
//                print(granted)
//            }
//        } else {
//            // Fallback on earlier versions
//        }
        server.startBrowse()
        view.addSubview(tableView)
        view.addSubview(contentView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(64)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.snp.centerY)
        }
        contentView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
//        if #available(iOS 14.0, *) {
//            VTLocalNetworkPermission().requestAuthorization { result in
//                print(result)
//            }
//        } else {
//            // Fallback on earlier versions
//        }
//        alert()
    }

    func alert() {
        // 创建服务浏览参数
        let parameters = NWParameters()
        parameters.includePeerToPeer = true

        // 设置服务浏览描述符
        if #available(iOS 13.0, *) {
            let browserDescriptor = NWBrowser.Descriptor.bonjour(type: "_sraf-rc._tcp", domain: nil)
            // 创建 NWBrowser
            let browser = NWBrowser(for: browserDescriptor, using: parameters)
            print(browser.state)

            // 设置浏览状态更新处理程序
            browser.stateUpdateHandler = { newState in
                switch newState {
                case .setup:
                    print("浏览器正在设置")
                case .waiting(let error):
                    print("浏览器等待中: \(error)")
                    switch error {
                    case .posix(let code):
                        print("code:\(code)")
                        break
                    case .dns(let type):
                        print("type:\(type)")
                        break
                    case .tls(let status):
                        print("status:\(status)")
                        break
                    @unknown default:
                        break
                    }
                case .ready:
                    print("浏览器已准备好并正在浏览")
                case .failed(let error):
                    print("浏览器失败: \(error)")
//                    self.browser?.cancel()
                case .cancelled:
                    print("浏览器已取消")
                @unknown default:
                    fatalError("未知状态")
                }
            }

            // 设置发现结果更新处理程序
            browser.browseResultsChangedHandler = { results, changes in
                print("result:\(results),,,changes:\(changes)")
//                self.discoveredServices = Array(results)
//                self.handleBrowseResults(results)
            }

            // 启动浏览器
            browser.start(queue: .main)
        } else {
            // Fallback on earlier versions
        }

        
        
//        do {
//            let listener = try NWListener(using: NWParameters(tls: .none, tcp: NWProtocolTCP.Options()))
//            listener.service = NWListener.Service(name: UUID().uuidString, type: type)
//            listener.newConnectionHandler = { _ in } // Must be set or else the listener will error with POSIX error 22
//
//            let parameters = NWParameters()
//            parameters.includePeerToPeer = true
//            let browser = NWBrowser(for: .bonjour(type: type, domain: nil), using: parameters)
//                
//            // [...]
//
//            listener.stateUpdateHandler = { newState in
//                // Handle listener error/cancellation states
//            }
//            listener.start(queue: queue)
//
//            browser.stateUpdateHandler = { newState in
//                // Handle error/cancellation states, especially the wait state with the kDNSServiceErr_PolicyDenied error
//            }
//            browser.browseResultsChangedHandler = { results, changes in
//                // Check whether a listener is found, this indicates we have permission
//            }
//            browser.start(queue: queue)
//        } catch {
//            
//        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dataView.resign()
    }
    
    private lazy var server: BonjourBrowser = {
        let server = BonjourBrowser()
        server.delegate = self
        return server
    }()

    private lazy var tableView:UITableView = {
        let tableView = UITableView.init(frame: .zero, style: UITableView.Style.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .orange
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ID")
        return tableView
    }()
    
    private lazy var contentView: CmdView = {
        let view = CmdView()
        view.callback = { [weak self] cmd in
            self?.server.sendCmd(cmd: cmd)
        }
        return view
    }()
    
    private lazy var dataView: DataView = {
        let view = DataView(firstText: "From Client", secondText: "To Client")
        view.toContentTextField.text = "456"
        view.sendCallback = { [weak self] text in
            self?.server.sendCmd(cmd: .volumeDown)
        }
        return view
    }()
}

extension ServerController: BonjourBrowserDelegate {
    
    func onConnected() {
        
    }
    
    func onDisconnected() {
        
    }
    
    func onHandleBody(_ body: NSString?) {
        guard let body = body as? String else { return }
        dataView.setText(body)
    }
    
    func onServicesChanged(_ browser: BonjourBrowser) {
        tableView.reloadData()
    }
      
    func onDidStopSearch(_ browser: BonjourBrowser) {
        browser.stopBrowsing()
    }
    
    func onDidNotSearch(_ browser: BonjourBrowser, errorDict: [String : NSNumber]) {
        print("net service did no Search. errorDict: \(errorDict)")
        browser.stopBrowsing()
    }
    
    func onDidNotResolveService(_ browser: BonjourBrowser, service: NetService, errorDict: [String : NSNumber]) {
        print("net service did no resolve. errorDict: \(errorDict)")
//        service.delegate = nil
//        service.stopMonitoring()
        UIApplication.shared.windows.first?.makeToast("解析失败: \(errorDict["NSNetServicesErrorCode"])")
    }
}

extension ServerController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return server.devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ID") ?? UITableViewCell()
        var text = server.devices[indexPath.row].name
        if let ip = server.connectedIP {
            text += " ==> \(ip):\(server.connectedPort)"
        }
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = text
        cell.contentView.backgroundColor = .yellow
        return cell
    }
    
}

extension ServerController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let service = server.devices[indexPath.row]
        server.connectTo(service)
    }
    
}
