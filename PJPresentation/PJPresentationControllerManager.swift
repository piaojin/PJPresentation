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
    
    @discardableResult
    public static func presentView(contentView: UIView, presentationViewControllerHeight: CGFloat, fromViewController: UIViewController? = PJViewController.shared.modalViewController(), presentationOptions: PJPresentationOptions = PJPresentationOptions()) -> PJPresentationViewController {
        let presentViewController = PJPresentationViewController(presentationViewControllerHeight: presentationViewControllerHeight, contentView: contentView, presentationOptions: presentationOptions)
        //UIModalPresentationStyle
        presentViewController.modalPresentationStyle = .custom
        var tempOptions = PJPresentationOptions.copyPresentationOptions(presentationOptions: presentationOptions)
        tempOptions.presentationViewControllerHeight = presentationViewControllerHeight
        presentViewController.presentationOptions = tempOptions
        var viewController: UIViewController?
        if let fromViewController = fromViewController {
            viewController = fromViewController
        } else if let fromViewController = PJViewController.shared.rootViewController() {
            viewController = fromViewController
        }
        viewController?.present(presentViewController, animated: true, completion: nil)
        presentedViewControllers.append(presentViewController)
        return presentViewController
    }
    
    @discardableResult
    public static func presentViewAtBottom(contentView: UIView, presentationViewControllerHeight: CGFloat, fromViewController: UIViewController? = PJViewController.shared.modalViewController(), contentViewSize: CGSize = .zero) -> PJPresentationViewController {
        var options = PJPresentationOptions()
        if contentViewSize != .zero {
            options.contentViewLayoutContants = PJLayoutAnchorContants(leadingContant: 0.0, trailingContant: 0.0, topContant: 0.0, bottomContant: 0.0, widthContant: contentViewSize.width, heightContant: contentViewSize.height)
        }
        return self.presentView(contentView: contentView, presentationViewControllerHeight: presentationViewControllerHeight, fromViewController: fromViewController, presentationOptions: options)
    }
    
    @discardableResult
    public static func presentViewAtCenter(contentView: UIView, presentationViewControllerHeight: CGFloat, fromViewController: UIViewController? = PJViewController.shared.modalViewController(), contentViewSize: CGSize = .zero) -> PJPresentationViewController {
        var options = PJPresentationOptions()
        options.presentationPosition = .center
        options.presentationDirection = .center
        options.dismissDirection = .center
        if contentViewSize != .zero {
            options.contentViewLayoutContants = PJLayoutAnchorContants(leadingContant: 0.0, trailingContant: 0.0, topContant: 0.0, bottomContant: 0.0, widthContant: contentViewSize.width, heightContant: contentViewSize.height)
        }
        return self.presentView(contentView: contentView, presentationViewControllerHeight: presentationViewControllerHeight, fromViewController: fromViewController, presentationOptions: options)
    }
    
    @discardableResult
    public static func presentViewAtTop(contentView: UIView, presentationViewControllerHeight: CGFloat, fromViewController: UIViewController? = PJViewController.shared.modalViewController(), contentViewSize: CGSize = .zero) -> PJPresentationViewController {
        var options = PJPresentationOptions()
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
}
