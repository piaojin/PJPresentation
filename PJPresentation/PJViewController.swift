//
//  PJViewController.swift
//  PJPresentation
//
//  Created by piaojin on 2023/9/17.
//

import Foundation

public struct PJViewController {
    public static let shared = PJViewController()
    
    public func rootViewController() -> UIViewController? {
        return UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController
    }

    public func modalViewController() -> UIViewController? {
        var viewController: UIViewController? = rootViewController()
        
        while let presentedViewController = viewController?.presentedViewController {
            viewController = presentedViewController
        }

        return viewController
    }
    
    public func displayViewController() -> UIViewController? {
        guard let appDelegate = UIApplication.shared.delegate else {
            return nil
        }
        
        guard let window = appDelegate.window else {
            return nil
        }
        
        var result = window?.rootViewController
        while result?.presentedViewController != nil {
            result = result?.presentedViewController
        }

        if result is UITabBarController {
            result = (result as? UITabBarController)?.selectedViewController
        }
        
        if result is UINavigationController {
            result = (result as? UINavigationController)?.topViewController
        }

        return result
    }
}

