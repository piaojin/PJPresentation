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
    public static var presentedViewControllers: PJWeakArray<UIViewController> = PJWeakArray([])
    
    /// The top displaying ViewController
    public static var topViewController: PJPresentationProtocol? {
        return presentedViewControllers.last as? PJPresentationProtocol
    }
    
    /// The top displaying ContentView
    public static var topContentView: UIView? {
        if topViewController is PJPresentationViewController, let vc = topViewController as? PJPresentationViewController {
            return vc.contentView
        }
        return topViewController?.view
    }
    
    /// Is current displaying ContentView
    public static var isDisplaying: Bool {
        return !presentedViewControllers.isEmpty
    }
    
    /// Retry present viewcontroller count when present failed.
    private static var reTryCountDic: [Int: Int] = [:]
    
    /// Note: Need set transitioningDelegate = self in UIViewController's init.
    @discardableResult
    public static func present(_ presentViewController: PJPresentationProtocol, fromViewController: UIViewController? = nil, completion: (() -> Void)? = nil, dismissHandler: (() -> Void)? = nil) -> PJPresentationProtocol {
        assert(presentViewController.transitioningDelegate != nil, "Need set transitioningDelegate = self in UIViewController which implement PJPresentationProtocol.")
        presentViewController.modalPresentationStyle = .custom
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
    
    /// Present contentView
    /// - Parameter contentWidth: Set contentWidth to specify contentView's width otherwise will fill up the screen.
    /// - Parameter contentHeight: Set contentHeight to specify contentView's height otherwise will use the contentView's autolayout's height.
    /// - Parameter top, bottom, leading, trailing: The contentView top, bottom, leading, trailing constraints to the PJPresentationViewController's view.
    /// - Parameter PJAnchorContant: Set isAlignSafeArea = true if want align safe areas.
    @discardableResult
    public static func presentView(contentView: UIView, fromViewController: UIViewController? = nil, contentWidth: CGFloat = 0, contentHeight: CGFloat = 0, top: PJAnchorContant = PJAnchorContantDefault, bottom: PJAnchorContant = PJAnchorContantDefault, leading: PJAnchorContant = PJAnchorContantDefault, trailing: PJAnchorContant = PJAnchorContantDefault, presentationOptions: PJPresentationOptions = PJPresentationOptions(), completion: (() -> Void)? = nil, dismissHandler: (() -> Void)? = nil) -> PJPresentationViewController {
        let presentViewController = PJPresentationViewController(contentView: contentView, presentationOptions: presentationOptions)
        presentViewController.modalPresentationStyle = .custom
        var options = PJPresentationOptions.copyPresentationOptions(presentationOptions: presentationOptions)
        options.contentViewLayoutContants = (leading: leading, trailing: trailing, top: top, bottom: bottom, width: contentWidth, height: contentHeight)
        presentViewController.presentationOptions = options
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
    
    /// Present contentView at bottom and will reset presentationOptions's presentAt = .bottom, presentFromDirection = .bottomToTop, dismissFromDirection = .topToBottom
    /// - Parameter contentWidth: Set contentWidth to specify contentView's width otherwise will fill up the screen.
    /// - Parameter contentHeight: Set contentHeight to specify contentView's height otherwise will use the contentView's autolayout's height.
    /// - Parameter top, bottom, leading, trailing: The contentView top, bottom, leading, trailing constraints to the PJPresentationViewController's view.
    /// - Parameter PJAnchorContant: Set isAlignSafeArea = true if want align safe areas.
    @discardableResult
    public static func presentViewAtBottom(contentView: UIView, fromViewController: UIViewController? = PJViewController.shared.modalViewController(), contentWidth: CGFloat = 0, contentHeight: CGFloat = 0, top: PJAnchorContant = PJAnchorContantDefault, bottom: PJAnchorContant = PJAnchorContantDefault, leading: PJAnchorContant = PJAnchorContantDefault, trailing: PJAnchorContant = PJAnchorContantDefault, presentationOptions: PJPresentationOptions = PJPresentationOptions(), completion: (() -> Void)? = nil, dismissHandler: (() -> Void)? = nil) -> PJPresentationViewController {
        var options = PJPresentationOptions.copyPresentationOptions(presentationOptions: presentationOptions)
        options.presentAt = .bottom
        options.presentFromDirection = .bottomToTop
        options.dismissFromDirection = .topToBottom
        return presentView(contentView: contentView, fromViewController: fromViewController, contentWidth: contentWidth, contentHeight: contentHeight, top: top, bottom: bottom, leading: leading, trailing: trailing, presentationOptions: options, completion: completion, dismissHandler: dismissHandler)
    }
    
    /// Present contentView at center and will reset presentationOptions's presentAt = .center, presentFromDirection = .center, dismissFromDirection = .center
    /// - Parameter contentWidth: Set contentWidth to specify contentView's width otherwise will fill up the screen.
    /// - Parameter contentHeight: Set contentHeight to specify contentView's height otherwise will use the contentView's autolayout's height.
    /// - Parameter top, bottom, leading, trailing: The contentView top, bottom, leading, trailing constraints to the PJPresentationViewController's view.
    /// - Parameter PJAnchorContant: Set isAlignSafeArea = true if want align safe areas.
    @discardableResult
    public static func presentViewAtCenter(contentView: UIView, fromViewController: UIViewController? = PJViewController.shared.modalViewController(), contentWidth: CGFloat = 0, contentHeight: CGFloat = 0, top: PJAnchorContant = PJAnchorContantDefault, bottom: PJAnchorContant = PJAnchorContantDefault, leading: PJAnchorContant = PJAnchorContantDefault, trailing: PJAnchorContant = PJAnchorContantDefault, presentationOptions: PJPresentationOptions = PJPresentationOptions(), completion: (() -> Void)? = nil, dismissHandler: (() -> Void)? = nil) -> PJPresentationViewController {
        var options = PJPresentationOptions.copyPresentationOptions(presentationOptions: presentationOptions)
        options.presentAt = .center
        options.presentFromDirection = .center
        options.dismissFromDirection = .center
        return presentView(contentView: contentView, fromViewController: fromViewController, contentWidth: contentWidth, contentHeight: contentHeight, top: top, bottom: bottom, leading: leading, trailing: trailing, presentationOptions: options, completion: completion, dismissHandler: dismissHandler)
    }
    
    /// Present contentView at top and will reset presentationOptions's presentAt = .top, presentFromDirection = .topToBottom, dismissFromDirection = .bottomToTop
    /// - Parameter contentWidth: Set contentWidth to specify contentView's width otherwise will fill up the screen.
    /// - Parameter contentHeight: Set contentHeight to specify contentView's height otherwise will use the contentView's autolayout's height.
    /// - Parameter top, bottom, leading, trailing: The contentView top, bottom, leading, trailing constraints to the PJPresentationViewController's view.
    /// - Parameter PJAnchorContant: Set isAlignSafeArea = true if want align safe areas.
    @discardableResult
    public static func presentViewAtTop(contentView: UIView, fromViewController: UIViewController? = PJViewController.shared.modalViewController(), contentWidth: CGFloat = 0, contentHeight: CGFloat = 0, top: PJAnchorContant = PJAnchorContantDefault, bottom: PJAnchorContant = PJAnchorContantDefault, leading: PJAnchorContant = PJAnchorContantDefault, trailing: PJAnchorContant = PJAnchorContantDefault, presentationOptions: PJPresentationOptions = PJPresentationOptions(), completion: (() -> Void)? = nil, dismissHandler: (() -> Void)? = nil) -> PJPresentationViewController {
        var options = PJPresentationOptions.copyPresentationOptions(presentationOptions: presentationOptions)
        options.presentAt = .top
        options.presentFromDirection = .topToBottom
        options.dismissFromDirection = .bottomToTop
        return presentView(contentView: contentView, fromViewController: fromViewController, contentWidth: contentWidth, contentHeight: contentHeight, top: top, bottom: bottom, leading: leading, trailing: trailing, presentationOptions: options, completion: completion, dismissHandler: dismissHandler)
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
    
    private static func reTryToPresent(_ presentViewController: PJPresentationProtocol, _ fromViewController: UIViewController?, completion: (() -> Void)? = nil) {
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
