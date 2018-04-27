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
        return self.presentationOptions.transitionDuration
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
        toView.heightAnchor.constraint(equalToConstant: self.presentationOptions.presentationViewControllerHeight).isActive = true
        
        switch self.presentationOptions.presentationDirection {
        case .bottomToTop:
            self.fromBottomToTop(toView: toView, containerView: containerView, using: transitionContext)
            break
        case .topToBottom:
            self.fromTopToBottom(toView: toView, containerView: containerView, using: transitionContext)
            break
        case .center:
            self.fromCenter(toView: toView, containerView: containerView, using: transitionContext)
            break
        }
        toView.isHidden = false
        
        if self.presentationOptions.isUseSpringAnimation {
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: self.presentationOptions.delay, usingSpringWithDamping: self.presentationOptions.usingSpringWithDamping, initialSpringVelocity: self.presentationOptions.initialSpringVelocity, options: self.presentationOptions.options, animations: {
                toView.transform = .identity
            }) { (completed) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        } else {
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
                toView.transform = .identity
            }, completion: { (completed) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
    
    private func fromBottomToTop(toView: UIView, containerView: UIView, using transitionContext: UIViewControllerContextTransitioning) {
        switch self.presentationOptions.presentationPosition {
        case .bottom:
            self.fromBottomToTopPresentationPositionBottom(toView: toView, containerView: containerView, using: transitionContext)
            break
        case .top:
            self.fromBottomToTopPresentationPositionTop(toView: toView, containerView: containerView, using: transitionContext)
            break
        case .center:
            self.fromBottomToTopPresentationPositionCenter(toView: toView, containerView: containerView, using: transitionContext)
            break
        }
        toView.transform = CGAffineTransform(translationX: 0.0, y: containerView.frame.size.height)
    }
    
    private func fromTopToBottom(toView: UIView, containerView: UIView, using transitionContext: UIViewControllerContextTransitioning) {
        switch self.presentationOptions.presentationPosition {
        case .bottom:
            self.fromTopToBottomPresentationPositionBottom(toView: toView, containerView: containerView, using: transitionContext)
            toView.transform = CGAffineTransform(translationX: 0.0, y: -(containerView.frame.size.height - self.presentationOptions.presentationViewControllerHeight))
            break
        case .top:
            self.fromTopToBottomPresentationPositionTop(toView: toView, containerView: containerView, using: transitionContext)
            toView.transform = CGAffineTransform(translationX: 0.0, y: -self.presentationOptions.presentationViewControllerHeight)
            break
        case .center:
            self.fromTopToBottomPresentationPositionCenter(toView: toView, containerView: containerView, using: transitionContext)
            toView.transform = CGAffineTransform(translationX: 0.0, y: -(containerView.frame.size.height - self.presentationOptions.presentationViewControllerHeight) / 2.0)
            break
        }
    }
    
    private func fromCenter(toView: UIView, containerView: UIView, using transitionContext: UIViewControllerContextTransitioning) {
        toView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        toView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    }
    
    private func fromBottomToTopPresentationPositionBottom(toView: UIView, containerView: UIView, using transitionContext: UIViewControllerContextTransitioning) {
        toView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    private func fromBottomToTopPresentationPositionCenter(toView: UIView, containerView: UIView, using transitionContext: UIViewControllerContextTransitioning) {
        toView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    }
    
    private func fromBottomToTopPresentationPositionTop(toView: UIView, containerView: UIView, using transitionContext: UIViewControllerContextTransitioning) {
        toView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
    }
    
    private func fromTopToBottomPresentationPositionBottom(toView: UIView, containerView: UIView, using transitionContext: UIViewControllerContextTransitioning) {
        toView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    private func fromTopToBottomPresentationPositionCenter(toView: UIView, containerView: UIView, using transitionContext: UIViewControllerContextTransitioning) {
        toView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    }
    
    private func fromTopToBottomPresentationPositionTop(toView: UIView, containerView: UIView, using transitionContext: UIViewControllerContextTransitioning) {
        toView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
    }
}
