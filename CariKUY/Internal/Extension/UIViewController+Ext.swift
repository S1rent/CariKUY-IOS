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
    
    func presentPopUp(
        title: String,
        message: String,
        actions: [UIAlertAction],
        completion: (() -> Void)?
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in actions {
            alertController.addAction(action)
        }
        
        self.present(alertController, animated: true, completion: completion)
    }
}
