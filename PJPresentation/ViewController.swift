//
//  ViewController.swift
//  PJPresentation
//
//  Created by Zoey Weng on 2018/4/27.
//  Copyright © 2018年 piaojin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let rightButton = UIButton()
        rightButton.setTitle("click", for: .normal)
        rightButton.backgroundColor = .orange
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        rightButton.addTarget(self, action: #selector(click), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func click() {
        let contentView = UIView()
        contentView.backgroundColor = .orange
        PJPresentationManager.presentView(contentView: contentView, presentationViewControllerHeight: 200.0)
    }
}

