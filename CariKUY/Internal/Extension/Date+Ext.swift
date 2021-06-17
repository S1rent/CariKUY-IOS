//
//  Date+Ext.swift
//  CariKUY
//
//  Created by IT Division on 18/06/21.
//

import Foundation

extension Date {
    public func formatDate(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
