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
    
    open var contentViewLayoutContants: PJLayoutAnchorContants {
        return self.presentationOptions.contentViewLayoutContants
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
    
//    deinit {
//        PJPresentationControllerManager.presentedViewControllers.remove(by: self.hash)
//        print("count: \(PJPresentationControllerManager.presentedViewControllers.count)")
//    }
}

extension PJPresentationViewController {
    private func initView() {
        self.view.backgroundColor = self.presentationOptions.backgroundColor
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.contentView)
        var contentViewLeadingAnchor: NSLayoutAnchor = self.view.leadingAnchor
        var contentViewTrailingAnchor: NSLayoutAnchor = self.view.trailingAnchor
        
        if #available(iOS 11.0, *) {
            contentViewLeadingAnchor = self.view.safeAreaLayoutGuide.leadingAnchor
            contentViewTrailingAnchor = self.view.safeAreaLayoutGuide.trailingAnchor
        }
        
        if contentViewLayoutContants.widthContant > 0, contentViewLayoutContants.heightContant > 0 {
            self.contentView.widthAnchor.constraint(equalToConstant: self.contentViewLayoutContants.widthContant).isActive = true
            self.contentView.heightAnchor.constraint(equalToConstant: self.contentViewLayoutContants.heightContant).isActive = true
            self.contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        } else {
            self.contentView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.contentViewLayoutContants.topContant).isActive = true
            self.contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -self.contentViewLayoutContants.bottomContant).isActive = true
            self.contentView.leadingAnchor.constraint(equalTo: contentViewLeadingAnchor, constant: self.contentViewLayoutContants.leadingContant).isActive = true
            self.contentView.trailingAnchor.constraint(equalTo: contentViewTrailingAnchor, constant: -self.contentViewLayoutContants.trailingContant).isActive = true
        }
    }
}

extension PJPresentationViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = PJPresentationController(presentedViewController: presented, presenting: presenting)
        if self.presentationOptions.presentationViewControllerFrame == .zero {
            var frameOfPresentedViewInContainerView = CGRect.zero
            switch self.presentationPosition {
            case .bottom:
                frameOfPresentedViewInContainerView = CGRect(x: 0.0, y: presented.view.bounds.height - self.presentationViewControllerHeight, width: presented.view.bounds.width, height: self.presentationViewControllerHeight)
                break
            case .center:
                frameOfPresentedViewInContainerView = CGRect(x: 0.0, y: presented.view.center.y - self.presentationViewControllerHeight / 2.0, width: presented.view.bounds.width, height: self.presentationViewControllerHeight)
                break
            case .top:
                frameOfPresentedViewInContainerView = CGRect(x: 0.0, y: 0.0, width: presented.view.bounds.width, height: self.presentationViewControllerHeight)
                break
            }
            presentationController.dismissClosure = {
                self.dismiss(animated: true, completion: self.dismissClosure)
                PJPresentationControllerManager.presentedViewControllers.remove(by: self.hash)
            }
            self.presentationOptions.frameOfPresentedViewInContainerView = frameOfPresentedViewInContainerView
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
