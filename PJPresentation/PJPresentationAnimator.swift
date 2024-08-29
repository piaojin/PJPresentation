//
//  PJPresentationAnimator.swift
//  UIPresentationControllerDemo
//
//  Created by Zoey Weng on 2018/4/10.
//  Copyright © 2018年 Zoey Weng. All rights reserved.
//

import UIKit

open class PJPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    open var presentationOptions: PJPresentationOptions = PJPresentationOptions()
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return presentationOptions.transitionDuration
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containerView = transitionContext.containerView
        guard let toView = toViewController?.view  else {
            return
        }
        
        toView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(toView)
        
        toView.isHidden = true
        toView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        toView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        switch presentationOptions.presentFromDirection {
        case .bottomToTop:
            presentFromBottom(toView: toView, containerView: containerView, using: transitionContext)
        case .topToBottom:
            presentFromTop(toView: toView, containerView: containerView, using: transitionContext)
        case .center:
            fromCenter(toView: toView, containerView: containerView, using: transitionContext)
        }
        toView.isHidden = false
        
        if presentationOptions.isUseSpringAnimation {
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: presentationOptions.delay, usingSpringWithDamping: presentationOptions.usingSpringWithDamping, initialSpringVelocity: presentationOptions.initialSpringVelocity, options: presentationOptions.options, animations: {
                toView.transform = .identity
            }) { (completed) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        } else {
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toView.transform = .identity
            }, completion: { (completed) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
    
    private func presentFromBottom(toView: UIView, containerView: UIView, using transitionContext: UIViewControllerContextTransitioning) {
        toView.layoutIfNeeded()
        switch presentationOptions.presentAt {
        case .bottom:
            toView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            toView.transform = CGAffineTransform(translationX: 0.0, y: toView.bounds.size.height)
        case .top:
            toView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            toView.transform = CGAffineTransform(translationX: 0.0, y: containerView.bounds.size.height)
        case .center:
            toView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            toView.transform = CGAffineTransform(translationX: 0.0, y: (containerView.bounds.size.height + toView.bounds.size.height) / 2)
        }
    }
    
    private func presentFromTop(toView: UIView, containerView: UIView, using transitionContext: UIViewControllerContextTransitioning) {
        toView.layoutIfNeeded()
        switch presentationOptions.presentAt {
        case .bottom:
            toView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            toView.transform = CGAffineTransform(translationX: 0.0, y: -containerView.frame.size.height)
        case .top:
            toView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            toView.transform = CGAffineTransform(translationX: 0.0, y: -toView.frame.size.height)
        case .center:
            toView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            toView.transform = CGAffineTransform(translationX: 0.0, y: -(containerView.frame.size.height + toView.frame.size.height) / 2.0)
        }
    }
    
    private func fromCenter(toView: UIView, containerView: UIView, using transitionContext: UIViewControllerContextTransitioning) {
        toView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        toView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    }
}
