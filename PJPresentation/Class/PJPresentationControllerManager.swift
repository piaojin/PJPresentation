//
//  PJPresentationControllerManager.swift
//  UIPresentationControllerDemo
//
//  Created by Zoey Weng on 2018/4/9.
//  Copyright © 2018年 Zoey Weng. All rights reserved.
//

import UIKit

class PJPresentationControllerManager: NSObject {
    
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
        return presentViewController
    }
    
    @discardableResult
    public static func presentView(contentView: UIView, presentationViewControllerHeight: CGFloat, presentationOptions: PJPresentationOptions = PJPresentationOptions()) -> PJPresentationViewController {
        return self.presentView(contentView: contentView, presentationViewControllerHeight: presentationViewControllerHeight, fromViewController: self.rootViewController(), presentationOptions: presentationOptions)
    }
    
    public static func dismiss(presentationViewController: PJPresentationViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentationViewController.dismiss(animated: flag, completion: completion)
    }
    
    private static func rootViewController() -> UIViewController? {
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
            if let rootViewController = appdelegate.window?.rootViewController {
                return rootViewController
            }
            return nil
        }
        return nil
    }
}
