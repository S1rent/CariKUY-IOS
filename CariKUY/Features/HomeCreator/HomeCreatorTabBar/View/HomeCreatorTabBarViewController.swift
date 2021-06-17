//
//  HomeCreatorTabBarViewController.swift
//  CariKUY
//
//  Created by IT Division on 17/06/21.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import NSObject_Rx

class HomeCreatorTabBarViewController: UITabBarController {

    let viewModel = HomeCreatorTabBarViewModel()
    let loadTrigger = BehaviorRelay<Void>(value: ())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupTabBarView()
        
        self.bindUI()
    }
    
    private func bindUI() {
        let output = self.viewModel.transform(
            input: HomeCreatorTabBarViewModel.Input(
                loadTrigger: self.loadTrigger.asDriverOnErrorJustComplete(),
                callback: self.changeNavigationBarTitle
            )
        )
        
        self.rx.disposeBag.insert(
            output.menus.drive(onNext: { [weak self] viewControllers in
                guard let self = self else { return }
                
                self.viewControllers = viewControllers
            })
        )
    }
    
    private func setupNavigationBar() {
        UINavigationBar.appearance().barTintColor = UIColor.black
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    private func setupTabBarView() {
        self.tabBar.tintColor = UIColor.white
        self.tabBar.barTintColor = UIColor.black
        self.tabBar.isTranslucent = false
    }
    
    func changeNavigationBarTitle(title: String) {
        self.title = title
    }
}

