//
//  CustomViewController.swift
//  PJPresentationExample
//
//  Created by piaojin on 2024/2/1.
//  Copyright © 2024 piaojin. All rights reserved.
//

import UIKit
import PJPresentation

class CustomViewController: UIViewController, PJPresentationProtocol {
    var presentationOptions: PJPresentation.PJPresentationOptions = PJPresentationOptions()
    
    var dismissClosure: (() -> Void)?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self
        view.backgroundColor = .systemGreen
        let contentView = UIView()
        contentView.backgroundColor = .orange
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 300),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CustomViewController {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return pj_presentationController(forPresented: presented, presenting: presenting, source: source)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return pj_animationController(forPresented: presented, presenting: presenting, source: source)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return pj_animationController(forDismissed: dismissed)
    }
}
