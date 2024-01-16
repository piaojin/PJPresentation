//
//  PJPresentationControllerManager.swift
//  UIPresentationControllerDemo
//
//  Created by Zoey Weng on 2018/4/9.
//  Copyright © 2018年 Zoey Weng. All rights reserved.
//

import UIKit

private final class PJWeakBox<A: AnyObject> where A: NSObjectProtocol  {
    weak var unbox: A?
    var hash: Int = -1
    init(_ value: A) {
        unbox = value
        hash = value.hash
    }
}

public struct PJWeakArray<Element: AnyObject> where Element: NSObjectProtocol {
    private var items: [PJWeakBox<Element>] = []
    
    var last: Element? {
        return items.last?.unbox
    }
    
    init(_ elements: [Element]) {
        items = elements.map { PJWeakBox($0) }
    }
}

extension PJWeakArray: Collection {
    public var startIndex: Int { return items.startIndex }
    public var endIndex: Int { return items.endIndex }
    
    public subscript(_ index: Int) -> Element? {
        return items[index].unbox
    }
    
    public func index(after idx: Int) -> Int {
        return items.index(after: idx)
    }
    
    public mutating func append(_ newElement: Element) {
        items.append(PJWeakBox(newElement))
    }
    
    public mutating func remove(by hash: Int) {
        if let index = items.firstIndex(where: {
            $0.hash == hash
        }) {
            items.remove(at: index)
        }
    }
    
    public mutating func removeAll() {
        items.removeAll()
    }
}

open class PJPresentationControllerManager: NSObject {
    /// The all presented ViewControllers
    public static var presentedViewControllers: PJWeakArray<PJPresentationViewController> = PJWeakArray([])
    
    /// The top displaying ViewController
    public static var topViewController: PJPresentationViewController? {
        return presentedViewControllers.last
    }
    
    /// The top displaying ContentView
    public static var topContentView: UIView? {
        return topViewController?.contentView
    }
    
    /// Is current displaying ContentView
    public static var isDisplaying: Bool {
        return !presentedViewControllers.isEmpty
    }
    
    /// Retry present viewcontroller count when present failed.
    private static var reTryCountDic: [Int: Int] = [:]
    
    @discardableResult
    public static func presentView(contentView: UIView, presentationViewControllerHeight: CGFloat, fromViewController: UIViewController? = nil, presentationOptions: PJPresentationOptions = PJPresentationOptions(), completion: (() -> Void)? = nil, dismissHandler: (() -> Void)? = nil) -> PJPresentationViewController {
        let presentViewController = PJPresentationViewController(contentView: contentView, presentationOptions: presentationOptions)
        // UIModalPresentationStyle
        presentViewController.modalPresentationStyle = .custom
        var tempOptions = PJPresentationOptions.copyPresentationOptions(presentationOptions: presentationOptions)
        tempOptions.presentationViewControllerHeight = presentationViewControllerHeight
        presentViewController.presentationOptions = tempOptions
        let viewController = getAvailableFromViewController(fromViewController)
        
        if viewController?.isBeingDismissed == true || viewController?.isBeingPresented == true {
            reTryToPresent(presentViewController, fromViewController)
        } else {
            viewController?.present(presentViewController, animated: true, completion: completion)
            presentedViewControllers.append(presentViewController)
        }
        
        presentViewController.dismissClosure = {
            dismissHandler?()
        }
        return presentViewController
    }
    
    /// Present contentView at bottom and will reset presentationOptions's presentationPosition = .bottom, presentationDirection = .bottomToTop, dismissDirection = .topToBottom
    @discardableResult
    public static func presentViewAtBottom(contentView: UIView, presentationViewControllerHeight: CGFloat, fromViewController: UIViewController? = PJViewController.shared.modalViewController(), contentViewSize: CGSize = .zero, presentationOptions: PJPresentationOptions = PJPresentationOptions(), completion: (() -> Void)? = nil, dismissHandler: (() -> Void)? = nil) -> PJPresentationViewController {
        var options = PJPresentationOptions.copyPresentationOptions(presentationOptions: presentationOptions)
        options.presentationPosition = .bottom
        options.presentationDirection = .bottomToTop
        options.dismissDirection = .topToBottom
        if contentViewSize != .zero {
            options.contentViewLayoutContants = PJLayoutAnchorContants(leadingContant: 0.0, trailingContant: 0.0, topContant: 0.0, bottomContant: 0.0, widthContant: contentViewSize.width, heightContant: contentViewSize.height)
        }
        return self.presentView(contentView: contentView, presentationViewControllerHeight: presentationViewControllerHeight, fromViewController: fromViewController, presentationOptions: options, completion: completion, dismissHandler: dismissHandler)
    }
    
    /// Present contentView at center and will reset presentationOptions's presentationPosition = .center, presentationDirection = .center, dismissDirection = .center
    @discardableResult
    public static func presentViewAtCenter(contentView: UIView, presentationViewControllerHeight: CGFloat, fromViewController: UIViewController? = PJViewController.shared.modalViewController(), contentViewSize: CGSize = .zero, presentationOptions: PJPresentationOptions = PJPresentationOptions(), completion: (() -> Void)? = nil, dismissHandler: (() -> Void)? = nil) -> PJPresentationViewController {
        var options = PJPresentationOptions.copyPresentationOptions(presentationOptions: presentationOptions)
        options.presentationPosition = .center
        options.presentationDirection = .center
        options.dismissDirection = .center
        if contentViewSize != .zero {
            options.contentViewLayoutContants = PJLayoutAnchorContants(leadingContant: 0.0, trailingContant: 0.0, topContant: 0.0, bottomContant: 0.0, widthContant: contentViewSize.width, heightContant: contentViewSize.height)
        }
        return self.presentView(contentView: contentView, presentationViewControllerHeight: presentationViewControllerHeight, fromViewController: fromViewController, presentationOptions: options, completion: completion, dismissHandler: dismissHandler)
    }
    
    /// Present contentView at top and will reset presentationOptions's presentationPosition = .top, presentationDirection = .topToBottom, dismissDirection = .bottomToTop
    @discardableResult
    public static func presentViewAtTop(contentView: UIView, presentationViewControllerHeight: CGFloat, fromViewController: UIViewController? = PJViewController.shared.modalViewController(), contentViewSize: CGSize = .zero, presentationOptions: PJPresentationOptions = PJPresentationOptions(), completion: (() -> Void)? = nil, dismissHandler: (() -> Void)? = nil) -> PJPresentationViewController {
        var options = PJPresentationOptions.copyPresentationOptions(presentationOptions: presentationOptions)
        options.presentationPosition = .top
        options.presentationDirection = .topToBottom
        options.dismissDirection = .bottomToTop
        if contentViewSize != .zero {
            options.contentViewLayoutContants = PJLayoutAnchorContants(leadingContant: 0.0, trailingContant: 0.0, topContant: 0.0, bottomContant: 0.0, widthContant: contentViewSize.width, heightContant: contentViewSize.height)
        }
        return self.presentView(contentView: contentView, presentationViewControllerHeight: presentationViewControllerHeight, fromViewController: fromViewController, presentationOptions: options, completion: completion, dismissHandler: dismissHandler)
    }
    
    public static func dismiss(presentationViewController: PJPresentationViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentationViewController.dismiss(animated: flag, completion: completion)
        PJPresentationControllerManager.presentedViewControllers.remove(by: presentationViewController.hash)
    }
    
    public static func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if let last = presentedViewControllers.last {
            last.dismiss(animated: flag, completion: completion)
            PJPresentationControllerManager.presentedViewControllers.remove(by: last.hash)
        } else {
            completion?()
        }
    }
    
    public static func dismissAll(animated flag: Bool, completion: (() -> Void)? = nil) {
        var dismissCount = presentedViewControllers.count
        for vc in presentedViewControllers {
            vc?.dismiss(animated: flag, completion: {
                dismissCount -= 1
                if dismissCount <= 0 {
                    completion?()
                }
            })
        }
        
        if presentedViewControllers.isEmpty {
            completion?()
        }
        
        PJPresentationControllerManager.presentedViewControllers.removeAll()
    }
    
    private static func reTryToPresent(_ presentViewController: PJPresentationViewController, _ fromViewController: UIViewController?, completion: (() -> Void)? = nil) {
        var reTryCount = reTryCountDic[presentViewController.hash]
        if reTryCount == nil {
            reTryCount = 3
            reTryCountDic[presentViewController.hash] = reTryCount
        }
        
        let count = reTryCount ?? 0
        if count >= 0 {
            reTryCountDic[presentViewController.hash] = count - 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                let viewController = getAvailableFromViewController(fromViewController)
                if viewController?.isBeingDismissed == true || viewController?.isBeingPresented == true {
                    reTryToPresent(presentViewController, fromViewController)
                } else {
                    viewController?.present(presentViewController, animated: true, completion: completion)
                    reTryCountDic[presentViewController.hash] = nil
                    presentedViewControllers.append(presentViewController)
                }
            }
        } else {
            reTryCountDic[presentViewController.hash] = nil
            #if DEBUG
            print("[PJPresentation] ⚠️⚠️⚠️The fromViewController is isBeingDismissed or isBeingPresented and may cause warning: Attempt to present <xxx> on <xxx> which is already presenting <xxx>")
            #endif
        }
    }
    
    private static func getAvailableFromViewController(_ sourceViewController: UIViewController?) -> UIViewController? {
        var viewController: UIViewController?
        if let sourceViewController = sourceViewController {
            viewController = sourceViewController
        } else if let sourceViewController = PJViewController.shared.displayViewController()  {
            viewController = sourceViewController
        }
        return viewController
    }
}
