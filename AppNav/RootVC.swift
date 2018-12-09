//
//  RootVC.swift
//  AppNav
//
//  Created by Neil Jain on 12/9/18.
//  Copyright © 2018 Neil Jain. All rights reserved.
//

import UIKit

class RootVC: UIViewController {
    
    private var parentVC: NavViewController?

    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: UIControl.State.normal)
        button.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(buttonAction), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "RootVC"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction))
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    @objc func addAction() {
        print("Add Action")
    }
    
    @objc func buttonAction() {
        let nextVC = TableVC()
        nextVC.title = "Table VC"
        parentVC?.push(viewController: nextVC)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if let parentVC = parent as? NavViewController {
            self.parentVC = parentVC
        }
    }

}
