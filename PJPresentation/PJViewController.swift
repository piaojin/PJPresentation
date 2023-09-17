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
}

