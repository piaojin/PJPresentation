//
//  ViewController.swift
//  PJPresentation
//
//  Created by Zoey Weng on 2018/4/27.
//  Copyright © 2018年 piaojin. All rights reserved.
//

import UIKit
import PJPresentation

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
    
    @objc func click() {
        
        let customVC = CustomViewController()
        PJPresentationControllerManager.present(customVC, dismissHandler:  {
            let contentView = UIView()
            contentView.backgroundColor = .orange
            
            //        ***Options way***
            var options = PJPresentationOptions()
            options.presentAt = .bottom
            options.dismissFromDirection = .topToBottom
            options.presentFromDirection = .bottomToTop
            PJPresentationControllerManager.presentView(contentView: contentView, contentHeight: 250, presentationOptions: options)
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                
                PJPresentationControllerManager.dismiss(animated: true) {
                    let contentView = UIView()
                    contentView.backgroundColor = .orange
                    
                    /****Simple way****/
                    //        PJPresentationControllerManager.presentView(contentView: contentView, contentHeight: 200.0)
                    
                    /****Options way****/
                    var options = PJPresentationOptions()
                    options.presentAt = .bottom
                    options.dismissFromDirection = .topToBottom
                    options.presentFromDirection = .bottomToTop
                    PJPresentationControllerManager.presentView(contentView: contentView, contentHeight: 250, presentationOptions: options)
                }
            }
        })
    }
}

