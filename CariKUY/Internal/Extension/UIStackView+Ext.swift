//
//  UIStackView+Ext.swift
//  CariKUY
//
//  Created by IT Division on 17/06/21.
//

import Foundation
import UIKit

extension UIStackView {
    func safelyRemoveAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
    
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
