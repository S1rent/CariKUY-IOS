//
//  HomeCreatorViewController.swift
//  CariKUY
//
//  Created by IT Division on 17/06/21.
//

import UIKit

class HomeCreatorViewController: UIViewController {

    let changeTitle: ((_ title: String) -> Void)
    
    init(callback: @escaping ((_ title: String) -> Void)) {
        self.changeTitle = callback
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserService.shared.logout()
        self.navigateAndSetRootViewController(viewController: LoginViewController())
    }

}
