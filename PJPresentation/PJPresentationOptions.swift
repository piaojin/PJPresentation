//
//  PJPresentationOptions.swift
//  UIPresentationControllerDemo
//
//  Created by Zoey Weng on 2018/4/13.
//  Copyright © 2018年 Zoey Weng. All rights reserved.
//

import UIKit

/// 弹出的位置, center: 从屏幕中心弹出
public enum PJPresentationPosition {
    case bottom, center, top
}
/// topToBottom: 从上往下
public enum PJPresentationDirection {
    case topToBottom, bottomToTop, center
}

/// Note: widthContant & heightContant 的优先级高于其他约束
public typealias PJLayoutAnchorContants = (leading: PJAnchorContant, trailing: PJAnchorContant, top: PJAnchorContant, bottom: PJAnchorContant, width: CGFloat, height: CGFloat)

public typealias PJAnchorContant = (contant: CGFloat, isAlignSafeArea: Bool)

public let PJAnchorContantDefault: PJAnchorContant = (contant: 0.0, isAlignSafeArea: false)

public struct PJPresentationOptions {
    // 视图最终显示位置
    public var presentAt : PJPresentationPosition = .bottom
    
    // 视图弹出方向
    public var presentFromDirection: PJPresentationDirection = .bottomToTop
    
    // 视图消失方向
    public var dismissFromDirection: PJPresentationDirection = .topToBottom
    
    public var backgroundColor: UIColor = .clear
    
    public var transitionDuration: TimeInterval = 0.3
    
    public var dismissTransitionDuration: TimeInterval = 0.3
    
    public var coverShowDuration: TimeInterval = 0.5
    
    public var coverDismissDuration: TimeInterval = 0.5
    
    // 决定了弹出框中contentView的frame
    public var contentViewLayoutContants: PJLayoutAnchorContants = (leading: PJAnchorContantDefault, trailing: PJAnchorContantDefault, top: PJAnchorContantDefault, bottom: PJAnchorContantDefault, width: 0.0, height: 0.0)
    
    public var coverViewBackColor = UIColor.black.withAlphaComponent(0.5)
    
    public var isShowCoverView = true
    
    public var isTapCoverViewToDissmiss = true
    
    public var isUseSpringAnimation = false
    
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
