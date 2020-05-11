//
//  Coding.swift
//  Clippr
//
//  Created by Viktor Radulov on 5/12/20.
//  Copyright © 2020 Viktor Radulov. All rights reserved.
//

import Foundation

protocol ClassFamily: Decodable {
    static var discriminator: Discriminator { get }
    func getType() -> AnyObject.Type
}

enum Discriminator: String, CodingKey {
    case type
}

extension KeyedDecodingContainer {
    func decode<T: Decodable, U: ClassFamily>(_ heterogeneousType: [T].Type, ofFamily family: U.Type, forKey key: K) throws -> [T] {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        var list = [T]()
        var tmpContainer = container
        while !container.isAtEnd {
            let typeContainer = try container.nestedContainer(keyedBy: Discriminator.self)
            let family: U = try typeContainer.decode(U.self, forKey: U.discriminator)
            if let type = family.getType() as? T.Type {
                list.append(try tmpContainer.decode(type))
            }
        }
        return list
    }
}
