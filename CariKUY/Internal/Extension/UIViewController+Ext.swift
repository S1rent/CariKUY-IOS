//
//  UIViewController+Ext.swift
//  CariKUY
//
//  Created by IT Division on 16/06/21.
//

import Foundation
import UIKit

extension UIViewController {
    func navigateAndSetRootViewController(viewController: UIViewController) {
        let rootViewController = UINavigationController(rootViewController: viewController)
        rootViewController.isNavigationBarHidden = true
        
        if let delegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            delegate.setRootViewController(viewController: rootViewController)
        }
    }
}
