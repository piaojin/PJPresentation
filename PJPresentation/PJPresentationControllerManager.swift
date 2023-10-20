//
//  PJPresentationControllerManager.swift
//  UIPresentationControllerDemo
//
//  Created by Zoey Weng on 2018/4/9.
//  Copyright © 2018年 Zoey Weng. All rights reserved.
//

import UIKit

private final class WeakBox<A: AnyObject> where A: NSObjectProtocol  {
    weak var unbox: A?
    var hash: Int = -1
    init(_ value: A) {
        unbox = value
        hash = value.hash
    }
}

internal struct WeakArray<Element: AnyObject> where Element: NSObjectProtocol {
    private var items: [WeakBox<Element>] = []
    
    var last: Element? {
        return items.last?.unbox
    }
    
    init(_ elements: [Element]) {
        items = elements.map { WeakBox($0) }
    }
}

extension WeakArray: Collection {
    var startIndex: Int { return items.startIndex }
    var endIndex: Int { return items.endIndex }
    
    subscript(_ index: Int) -> Element? {
        return items[index].unbox
    }
    
    func index(after idx: Int) -> Int {
        return items.index(after: idx)
    }
    
    mutating func append(_ newElement: Element) {
        items.append(WeakBox(newElement))
    }
    
    mutating func remove(by hash: Int) {
        if let index = items.firstIndex(where: {
            $0.hash == hash
        }) {
            items.remove(at: index)
        }
    }
    
    mutating func removeAll() {
        items.removeAll()
    }
}

open class PJPresentationControllerManager: NSObject {
    
    internal static var presentedViewControllers: WeakArray<PJPresentationViewController> = WeakArray([])
    
    private static var reTryCountDic: [Int: Int] = [:]
    
    @discardableResult
    public static func presentView(contentView: UIView, presentationViewControllerHeight: CGFloat, fromViewController: UIViewController? = nil, presentationOptions: PJPresentationOptions = PJPresentationOptions()) -> PJPresentationViewController {
        let presentViewController = PJPresentationViewController(presentationViewControllerHeight: presentationViewControllerHeight, contentView: contentView, presentationOptions: presentationOptions)
        //UIModalPresentationStyle
        presentViewController.modalPresentationStyle = .custom
        var tempOptions = PJPresentationOptions.copyPresentationOptions(presentationOptions: presentationOptions)
        tempOptions.presentationViewControllerHeight = presentationViewControllerHeight
        presentViewController.presentationOptions = tempOptions
        let viewController = getAvailableFromViewController(fromViewController)
        
        if viewController?.isBeingDismissed == true || viewController?.isBeingPresented == true {
            reTryToPresent(presentViewController, fromViewController)
        } else {
            viewController?.present(presentViewController, animated: true, completion: nil)
            presentedViewControllers.append(presentViewController)
        }
        
        return presentViewController
    }
    
    /// Present contentView at bottom and will reset presentationOptions's presentationPosition = .bottom, presentationDirection = .bottomToTop, dismissDirection = .topToBottom
    @discardableResult
    public static func presentViewAtBottom(contentView: UIView, presentationViewControllerHeight: CGFloat, fromViewController: UIViewController? = PJViewController.shared.modalViewController(), contentViewSize: CGSize = .zero, presentationOptions: PJPresentationOptions = PJPresentationOptions()) -> PJPresentationViewController {
        var options = PJPresentationOptions.copyPresentationOptions(presentationOptions: presentationOptions)
        options.presentationPosition = .bottom
        options.presentationDirection = .bottomToTop
        options.dismissDirection = .topToBottom
        if contentViewSize != .zero {
            options.contentViewLayoutContants = PJLayoutAnchorContants(leadingContant: 0.0, trailingContant: 0.0, topContant: 0.0, bottomContant: 0.0, widthContant: contentViewSize.width, heightContant: contentViewSize.height)
        }
        return self.presentView(contentView: contentView, presentationViewControllerHeight: presentationViewControllerHeight, fromViewController: fromViewController, presentationOptions: options)
    }
    
    /// Present contentView at center and will reset presentationOptions's presentationPosition = .center, presentationDirection = .center, dismissDirection = .center
    @discardableResult
    public static func presentViewAtCenter(contentView: UIView, presentationViewControllerHeight: CGFloat, fromViewController: UIViewController? = PJViewController.shared.modalViewController(), contentViewSize: CGSize = .zero, presentationOptions: PJPresentationOptions = PJPresentationOptions()) -> PJPresentationViewController {
        var options = PJPresentationOptions.copyPresentationOptions(presentationOptions: presentationOptions)
        options.presentationPosition = .center
        options.presentationDirection = .center
        options.dismissDirection = .center
        if contentViewSize != .zero {
            options.contentViewLayoutContants = PJLayoutAnchorContants(leadingContant: 0.0, trailingContant: 0.0, topContant: 0.0, bottomContant: 0.0, widthContant: contentViewSize.width, heightContant: contentViewSize.height)
        }
        return self.presentView(contentView: contentView, presentationViewControllerHeight: presentationViewControllerHeight, fromViewController: fromViewController, presentationOptions: options)
    }
    
    /// Present contentView at top and will reset presentationOptions's presentationPosition = .top, presentationDirection = .topToBottom, dismissDirection = .bottomToTop
    @discardableResult
    public static func presentViewAtTop(contentView: UIView, presentationViewControllerHeight: CGFloat, fromViewController: UIViewController? = PJViewController.shared.modalViewController(), contentViewSize: CGSize = .zero, presentationOptions: PJPresentationOptions = PJPresentationOptions()) -> PJPresentationViewController {
        var options = PJPresentationOptions.copyPresentationOptions(presentationOptions: presentationOptions)
        options.presentationPosition = .top
        options.presentationDirection = .topToBottom
        options.dismissDirection = .bottomToTop
        if contentViewSize != .zero {
            options.contentViewLayoutContants = PJLayoutAnchorContants(leadingContant: 0.0, trailingContant: 0.0, topContant: 0.0, bottomContant: 0.0, widthContant: contentViewSize.width, heightContant: contentViewSize.height)
        }
        return self.presentView(contentView: contentView, presentationViewControllerHeight: presentationViewControllerHeight, fromViewController: fromViewController, presentationOptions: options)
    }
    
    public static func dismiss(presentationViewController: PJPresentationViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentationViewController.dismiss(animated: flag, completion: completion)
        PJPresentationControllerManager.presentedViewControllers.remove(by: presentationViewController.hash)
    }
    
    public static func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if let last = presentedViewControllers.last {
            last.dismiss(animated: flag, completion: completion)
            PJPresentationControllerManager.presentedViewControllers.remove(by: last.hash)
        }
    }
    
    public static func dismissAll(animated flag: Bool, completion: (() -> Void)? = nil) {
        for vc in presentedViewControllers {
            vc?.dismiss(animated: flag, completion: completion)
        }
        PJPresentationControllerManager.presentedViewControllers.removeAll()
    }
    
    private static func reTryToPresent(_ presentViewController: PJPresentationViewController, _ fromViewController: UIViewController?) {
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
                    viewController?.present(presentViewController, animated: true, completion: nil)
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
