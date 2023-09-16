//
//  DemoViewController.swift
//  UIPresentationControllerDemo
//
//  Created by Zoey Weng on 2018/4/9.
//  Copyright © 2018年 Zoey Weng. All rights reserved.
//

import UIKit

open class PJPresentationController: UIPresentationController {
    //决定了弹出框的frame
    override open var frameOfPresentedViewInContainerView: CGRect {
        return self.presentationOptions.frameOfPresentedViewInContainerView
    }
    
    open var presentationOptions: PJPresentationOptions = PJPresentationOptions()
    
    //遮罩
    open var coverView: UIView = {
        let coverView = UIView()
        coverView.translatesAutoresizingMaskIntoConstraints = false
        coverView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        coverView.alpha = 0.0
        coverView.isUserInteractionEnabled = true
        return coverView
    }()
    
    open var dismissClosure: (() -> Void)?
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    //重写此方法可以在弹框即将显示时执行所需要的操作
    override open func presentationTransitionWillBegin() {
        if self.presentationOptions.isShowCoverView {
            self.containerView?.addSubview(self.coverView)
            if let containerView = self.containerView {
                self.coverView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
                self.coverView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
                self.coverView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
                self.coverView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            }
            
            UIView.animate(withDuration: 0.5) {
                self.coverView.alpha = 1.0
            }
            
            if self.presentationOptions.isTapCoverViewToDissmiss {
                let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
                self.coverView.addGestureRecognizer(tap)
            }
        }
    }
    
    //重写此方法可以在弹框显示完毕时执行所需要的操作
    override open func presentationTransitionDidEnd(_ completed: Bool) {
        
    }
    
    //重写此方法可以在弹框即将消失时执行所需要的操作
    override open func dismissalTransitionWillBegin() {
        UIView.animate(withDuration: 0.5) {
            self.coverView.alpha = 0.0
        }
    }
    
    //重写此方法可以在弹框消失之后执行所需要的操作
    override open func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.coverView.removeFromSuperview()
        }
    }
    
    @objc open func dismiss() {
        self.dismissClosure?()
    }
}
