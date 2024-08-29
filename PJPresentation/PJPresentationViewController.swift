//
//  PJPresentationViewController.swift
//  UIPresentationControllerDemo
//
//  Created by Zoey Weng on 2018/4/9.
//  Copyright © 2018年 Zoey Weng. All rights reserved.
//

import UIKit

/// Note: Need set transitioningDelegate = self in UIViewController's init which implement PJPresentationProtocol.
public protocol PJPresentationProtocol: UIViewController, NSObjectProtocol, UIViewControllerTransitioningDelegate {
    var presentationOptions: PJPresentationOptions { get set }
    var dismissClosure: (() -> Void)? { get set }
    func pj_presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?
    func pj_animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    func pj_animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
}

open class PJPresentationViewController: UIViewController, PJPresentationProtocol {
    open var presentationOptions: PJPresentationOptions = PJPresentationOptions()
    
    open var dismissClosure: (() -> Void)?
    
    open var contentViewLayoutContants: PJLayoutAnchorContants {
        return presentationOptions.contentViewLayoutContants
    }
    
    open var contentView: UIView = UIView()
    
    convenience public init(contentView: UIView, presentationOptions: PJPresentationOptions) {
        self.init()
        self.presentationOptions = presentationOptions
        self.contentView = contentView
        transitioningDelegate = self
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
}

extension PJPresentationViewController {
    private func setUpView() {
        view.backgroundColor = presentationOptions.backgroundColor
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        var contentViewLeadingAnchor: NSLayoutAnchor = view.leadingAnchor
        var contentViewTrailingAnchor: NSLayoutAnchor = view.trailingAnchor
        var contentViewTopAnchor: NSLayoutAnchor = view.topAnchor
        var contentViewBottomAnchor: NSLayoutAnchor = view.bottomAnchor
        
        if #available(iOS 11.0, *) {
            if contentViewLayoutContants.top.isAlignSafeArea {
                contentViewTopAnchor = view.safeAreaLayoutGuide.topAnchor
            }
            
            if contentViewLayoutContants.bottom.isAlignSafeArea {
                contentViewBottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
            }
            
            if contentViewLayoutContants.leading.isAlignSafeArea {
                contentViewLeadingAnchor = view.safeAreaLayoutGuide.leadingAnchor
            }
            
            if contentViewLayoutContants.trailing.isAlignSafeArea {
                contentViewTrailingAnchor = view.safeAreaLayoutGuide.trailingAnchor
            }
        }
        
        if contentViewLayoutContants.width > 0 {
            contentView.widthAnchor.constraint(equalToConstant: contentViewLayoutContants.width).isActive = true
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        } else {
            contentView.leadingAnchor.constraint(equalTo: contentViewLeadingAnchor, constant: contentViewLayoutContants.leading.contant).isActive = true
            contentView.trailingAnchor.constraint(equalTo: contentViewTrailingAnchor, constant: contentViewLayoutContants.trailing.contant).isActive = true
        }
        
        if contentViewLayoutContants.height > 0 {
            contentView.heightAnchor.constraint(equalToConstant: contentViewLayoutContants.height).isActive = true
        }
        
        contentView.topAnchor.constraint(equalTo: contentViewTopAnchor, constant: contentViewLayoutContants.top.contant).isActive = true
        contentView.bottomAnchor.constraint(equalTo: contentViewBottomAnchor, constant: contentViewLayoutContants.bottom.contant).isActive = true
    }
}

extension PJPresentationProtocol {
    public func pj_presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = PJPresentationController(presentedViewController: presented, presenting: presenting)
        presentationController.dismissClosure = { [weak self] in
            self?.dismiss(animated: true, completion: self?.dismissClosure)
            if let self {
                PJPresentationControllerManager.presentedViewControllers.remove(by: self.hash)
            }
        }
        presentationController.presentationOptions = presentationOptions
        return presentationController
    }
    
    public func pj_animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let customPresentationAnimator = presentationOptions.customPresentationAnimator {
            return customPresentationAnimator
        }
        let presentationAnimator = PJPresentationAnimator()
        presentationAnimator.presentationOptions = presentationOptions
        return presentationAnimator
    }
    
    public func pj_animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let customDismissAnimator = presentationOptions.customDismissAnimator {
            return customDismissAnimator
        }
        let dismissAnimator = PJDismissAnimator()
        dismissAnimator.presentationOptions = presentationOptions
        return dismissAnimator
    }
}

extension PJPresentationViewController {
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
