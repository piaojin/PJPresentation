//
//  PJPresentationViewController.swift
//  UIPresentationControllerDemo
//
//  Created by Zoey Weng on 2018/4/9.
//  Copyright © 2018年 Zoey Weng. All rights reserved.
//

import UIKit

open class PJPresentationViewController: UIViewController {

    open var presentationOptions: PJPresentationOptions = PJPresentationOptions()
    
    open var presentationViewControllerHeight: CGFloat {
        return self.presentationOptions.presentationViewControllerHeight
    }
    
    open var dismissClosure: (() -> Void)?
    
    open var didShowPresentationViewClosure: ((PJPresentationViewController) -> Void)?
    
    open var presentationPosition: PJPresentationPosition {
        return self.presentationOptions.presentationPosition
    }
    
    open var contentViewLayoutAnchors: PJLayoutAnchors {
        return self.presentationOptions.contentViewLayoutAnchors
    }
    
    open var contentView: UIView = UIView()
    
    convenience public init(presentationViewControllerHeight: CGFloat, contentView: UIView, presentationOptions: PJPresentationOptions) {
        self.init()
        self.presentationOptions = presentationOptions
        self.contentView = contentView
        self.transitioningDelegate = self
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.didShowPresentationViewClosure?(self)
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PJPresentationViewController {
    private func initView() {
        self.view.backgroundColor = .white
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.contentView)
        self.contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.contentViewLayoutAnchors.leadingAnchorContant).isActive = true
        self.contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -self.contentViewLayoutAnchors.trailingAnchorContant).isActive = true
        if #available(iOS 11.0, *) {
            self.contentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: self.contentViewLayoutAnchors.topAnchorContant).isActive = true
            self.contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -self.contentViewLayoutAnchors.bottomAnchorContant).isActive = true
        } else {
            self.contentView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: self.contentViewLayoutAnchors.topAnchorContant).isActive = true
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.bottomAnchor, constant: -self.contentViewLayoutAnchors.bottomAnchorContant).isActive = true
        }
    }
}

extension PJPresentationViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = PJPresentationController(presentedViewController: presented, presenting: presenting)
        if self.presentationOptions.presentationViewControllerFrame == .zero {
            var contentViewFrame = CGRect.zero
            switch self.presentationPosition {
            case .bottom:
                contentViewFrame = CGRect(x: 0.0, y: presented.view.bounds.height - self.presentationViewControllerHeight, width: presented.view.bounds.width, height: self.presentationViewControllerHeight)
                break
            case .center:
                contentViewFrame = CGRect(x: 0.0, y: presented.view.center.y - self.presentationViewControllerHeight / 2.0, width: presented.view.bounds.width, height: self.presentationViewControllerHeight)
                break
            case .top:
                contentViewFrame = CGRect(x: 0.0, y: 0.0, width: presented.view.bounds.width, height: self.presentationViewControllerHeight)
                break
            }
            presentationController.dismissClosure = {
                self.dismiss(animated: true, completion: self.dismissClosure)
            }
            self.presentationOptions.contentViewFrame = contentViewFrame
        }
        presentationController.presentationOptions = self.presentationOptions
        return presentationController
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let customPresentationAnimator = self.presentationOptions.customPresentationAnimator {
            return customPresentationAnimator
        }
        let presentationAnimator = PJPresentationAnimator()
        presentationAnimator.presentationOptions = self.presentationOptions
        return presentationAnimator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let customDismissAnimator = self.presentationOptions.customDismissAnimator {
            return customDismissAnimator
        }
        let dismissAnimator = PJDismissAnimator()
        dismissAnimator.presentationOptions = self.presentationOptions
        return dismissAnimator
    }
}
