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
        cache.setObject(object as AnyObject, forKey: key as NSString)
        let encoder = options.encoder

        func innerSave<T: Codable>(_ object: T) throws {
            let data = try encoder.encode(object)
            try fileManager
                .createFile(atPath: fileUrl(forKey: key).path, contents: data, attributes: nil)
                .trueOrThrow(StorageError.createFile)
        }

        do {
            try innerSave(object)
        } catch {
            let typeWrapper = TypeWrapper(object: object)
            try innerSave(typeWrapper)
        }
    }

    func load<T: Codable>(forKey key: String, as: T.Type) throws -> T {
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

        if let object = cache.object(forKey: key as NSString) as? T {
            return object
        } else {
            let object = try loadFromDisk(forKey: key, as: T.self)
            cache.setObject(object as AnyObject, forKey: key as NSString)
            return object
        }
    }
}
