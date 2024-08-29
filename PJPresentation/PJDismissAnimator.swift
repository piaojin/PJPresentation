//
//  PJDismissAnimator.swift
//  UIPresentationControllerDemo
//
//  Created by Zoey Weng on 2018/4/15.
//  Copyright © 2018年 Zoey Weng. All rights reserved.
//

import UIKit

open class PJDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    open var presentationOptions: PJPresentationOptions = PJPresentationOptions()
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return presentationOptions.dismissTransitionDuration
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let containerView = transitionContext.containerView
        guard let fromView = fromViewController?.view else {
            return
        }
        
        fromView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(fromView)
        fromView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        fromView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        var translationY: CGFloat = 0.0
        
        switch presentationOptions.presentAt {
        case .bottom:
            fromView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            if presentationOptions.dismissFromDirection == .topToBottom {
                translationY = fromView.bounds.height
            } else {
                translationY = -containerView.frame.size.height
            }
        case .top:
            fromView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            if presentationOptions.dismissFromDirection == .topToBottom {
                translationY = containerView.frame.size.height
            } else {
                translationY = -fromView.bounds.height
            }
        case .center:
            fromView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            translationY = positioninCenterTranslationY(fromView: fromView, containerView: containerView)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            if self.presentationOptions.dismissFromDirection == .center {
                fromView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            } else {
                fromView.transform = CGAffineTransform(translationX: 0.0, y: translationY)
            }
        }, completion: { (completed) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    private func positioninCenterTranslationY(fromView: UIView, containerView: UIView) -> CGFloat {
        var translationY: CGFloat = 0.0
        switch presentationOptions.dismissFromDirection {
        case .topToBottom:
            translationY = fromView.bounds.height + (containerView.frame.size.height - fromView.bounds.height) / 2.0
        case .bottomToTop:
            translationY = -fromView.bounds.height - (containerView.frame.size.height - fromView.bounds.height) / 2.0
        case .center:
            break
        }
        return translationY
    }
}
