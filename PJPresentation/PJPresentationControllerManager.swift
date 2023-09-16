//
//  PJPresentationControllerManager.swift
//  UIPresentationControllerDemo
//
//  Created by Zoey Weng on 2018/4/9.
//  Copyright © 2018年 Zoey Weng. All rights reserved.
//

import UIKit

private final class WeakBox<A: AnyObject> {
    weak var unbox: A?
    init(_ value: A) {
        unbox = value
    }
}

private struct WeakArray<Element: AnyObject> {
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
    
    mutating func append( _ newElement: Element) {
        items.append(WeakBox(newElement))
    }
}

open class PJPresentationControllerManager: NSObject {
    
    private static var presentedViewControllers: WeakArray<PJPresentationViewController> = WeakArray([])
    
    @discardableResult
    public static func presentView(contentView: UIView, presentationViewControllerHeight: CGFloat, fromViewController: UIViewController?, presentationOptions: PJPresentationOptions = PJPresentationOptions()) -> PJPresentationViewController {
        let presentViewController = PJPresentationViewController(presentationViewControllerHeight: presentationViewControllerHeight, contentView: contentView, presentationOptions: presentationOptions)
        //UIModalPresentationStyle
        presentViewController.modalPresentationStyle = .custom
        var tempOptions = PJPresentationOptions.copyPresentationOptions(presentationOptions: presentationOptions)
        tempOptions.presentationViewControllerHeight = presentationViewControllerHeight
        presentViewController.presentationOptions = tempOptions
        var viewController: UIViewController?
        if let fromViewController = fromViewController {
            viewController = fromViewController
        } else if let fromViewController = self.rootViewController() {
            viewController = fromViewController
        }
        viewController?.present(presentViewController, animated: true, completion: nil)
        presentedViewControllers.append(presentViewController)
        return presentViewController
    }
    
    @discardableResult
    public static func presentView(contentView: UIView, presentationViewControllerHeight: CGFloat, presentationOptions: PJPresentationOptions = PJPresentationOptions()) -> PJPresentationViewController {
        return self.presentView(contentView: contentView, presentationViewControllerHeight: presentationViewControllerHeight, fromViewController: self.rootViewController(), presentationOptions: presentationOptions)
    }
    
    public static func dismiss(presentationViewController: PJPresentationViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentationViewController.dismiss(animated: flag, completion: completion)
    }
    
    public static func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        presentedViewControllers.last?.dismiss(animated: flag, completion: completion)
    }
    
    public static func dismissAll(animated flag: Bool, completion: (() -> Void)? = nil) {
        for vc in presentedViewControllers {
            vc?.dismiss(animated: flag, completion: completion)
        }
    }
    
    private static func rootViewController() -> UIViewController? {
        
        guard let appdelegate = UIApplication.shared.delegate else {
            return nil
        }
        
        guard let window = appdelegate.window else {
            return nil
        }
        
        if let rootViewController = window?.rootViewController {
            return rootViewController
        }
        return nil
    }
}
