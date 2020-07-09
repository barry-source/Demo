//
//  ViewController.swift
//  Dynamics
//
//  Created by TSC on 2020/2/28.
//  Copyright © 2020 TSC. All rights reserved.
//

import UIKit

struct Datasource {
    let values = ["重力行为", "碰撞检测", "附着行为", "吸附行为", "推动行为" , "场行为--模仿漩涡", "场行为--弹性振子运行", "场行为--线性重力运行"]
    
    func title(for index: Int) -> String? {
        guard index < values.count else { return nil }
        return String(values[index])
    }
}

enum BehaviorType: Int {
    case gravity
    case collision
    case attachmentp
    case snap
    case push
    case field
    case fieldSpring
    case fieldLinearGravity
}

class ViewController: UIViewController {
    let datasource = Datasource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TestCell")
        tableView.rowHeight = 50
        return tableView
    }()
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = datasource.title(for: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = BehaviorType(rawValue: indexPath.row) else { return }
        switch type {

        case .gravity:
            navigationController?.pushViewController(GravigyViewController(), animated: true)
        case .collision:
            navigationController?.pushViewController(CollisionViewController(), animated: true)
        case .attachmentp:
            navigationController?.pushViewController(AttachmentViewController(), animated: true)
        case .snap:
            navigationController?.pushViewController(SnapViewController(), animated: true)
        case .push:
            navigationController?.pushViewController(PushViewController(), animated: true)
        case .field:
            navigationController?.pushViewController(FieldViewController(), animated: true)
        case .fieldSpring:
            navigationController?.pushViewController(FieldViewControllerBouce(), animated: true)
        case .fieldLinearGravity:
            navigationController?.pushViewController(FieldViewControllerLinearGravity(), animated: true)
        }
    }
}
