//
//  FourCharCode+Extensions.swift
//  Clippr
//
//  Created by Viktor Radulov on 5/11/20.
//  Copyright © 2020 Viktor Radulov. All rights reserved.
//

import Foundation

extension FourCharCode: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: Self.StringLiteralType) {
        self.init()
        for char in value.utf16 {
          self = (self << 8) + FourCharCode(char)
        }
    }
}
