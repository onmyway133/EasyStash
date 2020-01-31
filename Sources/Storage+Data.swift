//
//  Storage+Data.swift
//  EasyStash
//
//  Created by khoa on 27/05/2019.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

public extension Storage {
    func save(object: Data, forKey key: String) throws {
        try commonSave(object: object as AnyObject, forKey: key, toData: { object })
    }

    func load(forKey key: String, withExpiry expiry: Expiry = .never) throws -> Data {
        return try commonLoad(forKey: key, withExpiry: expiry, fromData: { $0 })
    }
}
