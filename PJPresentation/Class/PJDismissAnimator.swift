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
        return self.presentationOptions.dismissTransitionDuration
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
        fromView.heightAnchor.constraint(equalToConstant: self.presentationOptions.presentationViewControllerHeight).isActive = true
        
        var translationY: CGFloat = 0.0
        
        switch self.presentationOptions.presentationPosition {
        case .bottom:
            fromView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            if self.presentationOptions.dismissDirection == .topToBottom {
                translationY = self.presentationOptions.presentationViewControllerHeight
            } else {
                translationY = -containerView.frame.size.height
            }
            break
        case .top:
            fromView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            if self.presentationOptions.dismissDirection == .topToBottom {
                translationY = containerView.frame.size.height
            } else {
                translationY = -self.presentationOptions.presentationViewControllerHeight
            }
            break
        case .center:
            fromView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            translationY = self.positioninCenterTranslationY(containerView: containerView)
            break
        }
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            if self.presentationOptions.dismissDirection == .center {
                fromView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            } else {
                fromView.transform = CGAffineTransform(translationX: 0.0, y: translationY)
            }
        }, completion: { (completed) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    private func positioninCenterTranslationY(containerView: UIView) -> CGFloat {
        var translationY: CGFloat = 0.0
        switch self.presentationOptions.dismissDirection {
        case .topToBottom:
            translationY = self.presentationOptions.presentationViewControllerHeight + (containerView.frame.size.height - self.presentationOptions.presentationViewControllerHeight) / 2.0
            break
        case .bottomToTop:
            translationY = -self.presentationOptions.presentationViewControllerHeight - (containerView.frame.size.height - self.presentationOptions.presentationViewControllerHeight) / 2.0
            break
        case .center:
            break
        }
        return translationY
    }
}
