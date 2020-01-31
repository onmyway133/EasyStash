//
//  Storage+Codable.swift
//  EasyStash
//
//  Created by khoa on 27/05/2019.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

public extension Storage {
    func save<T: Codable>(object: T, forKey key: String) throws {
        let encoder = options.encoder
        try commonSave(object: object as AnyObject, forKey: key, toData: {
            do {
                return try encoder.encode(object)
            } catch {
                let typeWrapper = TypeWrapper(object: object)
                return try encoder.encode(typeWrapper)
            }
        })
    }

    func load<T: Codable>(forKey key: String, as: T.Type, withExpiry expiry: Expiry = .never) throws -> T {
        func loadFromDisk<T: Codable>(forKey key: String, as: T.Type) throws -> T {
            let data = try Data(contentsOf: fileUrl(forKey: key))
            let decoder = options.decoder

            do {
                let object = try decoder.decode(T.self, from: data)
                return object
            } catch {
                let typeWrapper = try decoder.decode(TypeWrapper<T>.self, from: data)
                return typeWrapper.object
            }
        }

        return try commonLoad(forKey: key, withExpiry: expiry, fromData: { data in
            return try loadFromDisk(forKey: key, as: T.self)
        })
    }
}
