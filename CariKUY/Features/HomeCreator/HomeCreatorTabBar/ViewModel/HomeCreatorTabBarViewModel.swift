//
//  HomeCreatorTabBarViewModel.swift
//  CariKUY
//
//  Created by IT Division on 17/06/21.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

final class HomeCreatorTabBarViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let callback: ((_ title: String) -> Void)
    }
    
    struct Output {
        let menus: Driver<[UIViewController]>
    }
    
    public func transform(input: Input) -> Output {
        let menus = input.loadTrigger.map { _ -> [UIViewController] in
            return [
                HomeCreatorViewController(callback: input.callback)
            ]
        }
        
        return Output(
            menus: menus
        )
    }
}
