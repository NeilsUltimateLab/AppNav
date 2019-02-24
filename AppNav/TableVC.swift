//
//  TableVC.swift
//  AppNav
//
//  Created by Neil Jain on 12/9/18.
//  Copyright © 2018 Neil Jain. All rights reserved.
//

import UIKit

class TableVC: UIViewController {

    var dataSource: [String] = []
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.contentInsetAdjustmentBehavior = .always
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = (0...100).compactMap({"Row: \($0 + 1)"})
        self.view.anchor(tableView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tableView.contentInset.top = self.view.superview?.safeAreaInsets.top ?? 0
    }

}

extension TableVC: UITableViewDelegate {
    
}

extension TableVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") else { return UITableViewCell() }
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
}
