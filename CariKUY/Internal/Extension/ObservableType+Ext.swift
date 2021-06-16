//
//  ObservableType+Ext.swift
//  CariKUY
//
//  Created by IT Division on 17/06/21.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in
            return Driver.empty()
        }
    }
}
