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

public typealias PJLayoutAnchors = (leadingAnchorContant: CGFloat, trailingAnchorContant: CGFloat, topAnchorContant: CGFloat, bottomAnchorContant: CGFloat)

public struct PJPresentationOptions {
    public var presentationPosition : PJPresentationPosition = .center
    
    public var presentationDirection: PJPresentationDirection = .topToBottom
    
    public var dismissDirection: PJPresentationDirection = .bottomToTop
    
    public var presentationViewControllerHeight: CGFloat = 0.0
    
    public var presentationViewControllerFrame: CGRect = .zero
    
    public var contentViewFrame: CGRect = .zero
    
    public var transitionDuration: TimeInterval = 0.5
    
    public var dismissTransitionDuration: TimeInterval = 0.5
    
    public var contentViewLayoutAnchors: PJLayoutAnchors = (leadingAnchorContant: 0.0, trailingAnchorContant: 0.0, topAnchorContant: 0.0, bottomAnchorContant: 0.0)
    
    public var coverViewBackColor = UIColor.black.withAlphaComponent(0.5)
    
    public var isShowCoverView = true
    
    public var isTapCoverViewToDissmiss = true
    
    public var isUseSpringAnimation = true
    
    public var customPresentationAnimator: UIViewControllerAnimatedTransitioning?
    
    public var customDismissAnimator: UIViewControllerAnimatedTransitioning?
    
    public var delay: TimeInterval = 0.0

    public var usingSpringWithDamping: CGFloat = 0.55

    public var initialSpringVelocity: CGFloat = 1.0 / 0.55
    
    public var options: UIViewAnimationOptions = .curveLinear
    
    public static func copyPresentationOptions(presentationOptions: PJPresentationOptions) -> PJPresentationOptions {
        return presentationOptions
    }
}
