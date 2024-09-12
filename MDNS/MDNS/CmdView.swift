//
//  CmdView.swift
//  MDNS
//
//  Created by 童世超 on 2024/7/15.
//

import UIKit

class CmdView: UIView {

    private var cmds = [
        "Power",
        "Home",
        "Up",
        "Down",
        "Left",
        "Right",
        "OK",
        "Back",
        "Menu",
        "Netflix",
        "Youtube",
        "Prime video",
        "OpenBrowser",
        "Volume down",
        "Volume up",
        "Volume mute",
        "Focus +",
        "Focus -",
    ]
    
    var callback: ((Command) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public

    // MARK: - Private

    
    // MARK: - UI
    
    private func setupUI() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: lazy load
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView.init(frame: .zero, style: UITableView.Style.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .orange
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "IDs")
        return tableView
    }()

}

extension CmdView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cmds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IDs") ?? UITableViewCell()
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = cmds[indexPath.row]
        cell.contentView.backgroundColor = .yellow
        return cell
    }
    
}

extension CmdView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch cmds[indexPath.row] {
        case "Power":
            callback?(.power)
        case "Home":
            callback?(.home)
        case "Up":
            callback?(.up)
        case "Down":
            callback?(.down)
        case "Left":
            callback?(.left)
        case "Right":
            callback?(.right)
        case "OK":
            callback?(.enter)
        case "Back":
            callback?(.back)
        case "Menu":
            callback?(.menu)
        case "Netflix":
            callback?(.pageUp)
        case "Youtube":
            callback?(.pageDown)
        case "Prime video":
            callback?(.update)
        case "OpenBrowser":
            callback?(.record)
        case "Volume down":
            callback?(.volumeDown)
        case "Volume up":
            callback?(.volumeUp)
        case "Volume mute":
            callback?(.volumeMute)
        case "Focus +":
            callback?(.channelUp)
        case "Focus -":
            callback?(.channelDown)
        default:
            break
        }
    }
    
}
