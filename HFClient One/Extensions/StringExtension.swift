//
//  StringExtension.swift
//  HiberLink
//
//  Created by Nathan FALLET on 19/04/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import Foundation

extension String {
    
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
    
    func format(_ args : CVarArg...) -> String {
        return String(format: self, locale: .current, arguments: args)
    }
    
    func format(_ args : [String]) -> String {
        return String(format: self, locale: .current, arguments: args)
    }
    
}
