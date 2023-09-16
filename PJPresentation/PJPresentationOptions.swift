//
//  PJPresentationOptions.swift
//  UIPresentationControllerDemo
//
//  Created by Zoey Weng on 2018/4/13.
//  Copyright © 2018年 Zoey Weng. All rights reserved.
//

import UIKit

public enum PJPresentationPosition {
    case bottom, center, top
}

public enum PJPresentationDirection {
    case topToBottom, bottomToTop, center
}

public typealias PJLayoutAnchorContants = (leadingContant: CGFloat, trailingContant: CGFloat, topContant: CGFloat, bottomContant: CGFloat, widthContant: CGFloat, heightContant: CGFloat)

public struct PJPresentationOptions {
    public var presentationPosition : PJPresentationPosition = .bottom
    
    public var presentationDirection: PJPresentationDirection = .bottomToTop
    
    public var dismissDirection: PJPresentationDirection = .topToBottom
    
    public var presentationViewControllerHeight: CGFloat = 0.0
    
    public var presentationViewControllerFrame: CGRect = .zero
    
    // 决定了弹出框的frame
    public var frameOfPresentedViewInContainerView: CGRect = .zero
    
    public var backgroundColor: UIColor = .clear
    
    public var transitionDuration: TimeInterval = 0.5
    
    public var dismissTransitionDuration: TimeInterval = 0.5
    
    // 决定了弹出框中contentView的frame
    public var contentViewLayoutContants: PJLayoutAnchorContants = (leadingContant: 0.0, trailingContant: 0.0, topContant: 0.0, bottomContant: 0.0, widthContant: 0.0, heightContant: 0.0)
    
    public var coverViewBackColor = UIColor.black.withAlphaComponent(0.5)
    
    public var isShowCoverView = true
    
    public var isTapCoverViewToDissmiss = true
    
    public var isUseSpringAnimation = true
    
    public var customPresentationAnimator: UIViewControllerAnimatedTransitioning?
    
    public var customDismissAnimator: UIViewControllerAnimatedTransitioning?
    
    public var delay: TimeInterval = 0.0

    public var usingSpringWithDamping: CGFloat = 0.55

    public var initialSpringVelocity: CGFloat = 1.0 / 0.55
    
    public var options: UIView.AnimationOptions = .curveLinear
    
    public init() {
        
    }
    
    public static func copyPresentationOptions(presentationOptions: PJPresentationOptions) -> PJPresentationOptions {
        return presentationOptions
    }
}
