//
//  MenuService.swift
//  CariKUY
//
//  Created by IT Division on 17/06/21.
//

import Foundation
import UIKit

enum UserRole {
    case seeker
    case creator
}

class MenuService {
    public static let shared = MenuService()
    private init() { }
    
    var callBack: ((_ title: String) -> Void)?
    
    func getMenu(userType: UserRole, callBack: @escaping ((_ title: String) -> Void)) -> [UIViewController] {
        self.callBack = callBack
        switch userType {
            case .seeker:
                return getSeekerMenuList()
            case .creator:
                return getCreatorMenuList()
        }
    }
    
    private func getSeekerMenuList() -> [UIViewController] {
        return [
            getSeekerHomeViewController(),
            getSeekerRegistrationListViewController(),
            getProfileViewController()
        ]
    }
    
    private func getCreatorMenuList() -> [UIViewController] {
        return [
            getSeekerHomeViewController(),
            getProfileViewController()
        ]
    }
    
    func getSeekerHomeViewController() -> UIViewController {
        if let callback = self.callBack {
            let viewController = HomeViewController(callback: callback)
            
            viewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
            viewController.tabBarItem.imageInsets = UIEdgeInsets.init(top: -5, left: -5, bottom: -5, right: -5)
            
            return viewController
        }
        return UIViewController()
    }
    
    func getSeekerRegistrationListViewController() -> UIViewController {
        if let callback = self.callBack {
            let viewController = HomeViewController(callback: callback)
            
            viewController.tabBarItem = UITabBarItem(title: "My Registration", image: UIImage(systemName: "list.bullet"), tag: 0)
            viewController.tabBarItem.imageInsets = UIEdgeInsets.init(top: -5, left: -5, bottom: -5, right: -5)
            
            return viewController
        }
        return UIViewController()
    }
    
    func getProfileViewController() -> UIViewController {
        if let callback = self.callBack {
            let viewController = ProfileViewController(callback: callback)
            
            viewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 0)
            viewController.tabBarItem.imageInsets = UIEdgeInsets.init(top: -5, left: -5, bottom: -5, right: -5)
            
            return viewController
        }
        return UIViewController()
    }
}
