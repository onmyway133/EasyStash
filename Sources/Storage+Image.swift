//
//  Storage+Image.swift
//  EasyStash
//
//  Created by khoa on 27/05/2019.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public extension Storage {
    func save(object: Image, forKey key: String) throws {
        try commonSave(object: object as AnyObject, forKey: key, toData: {
            return try unwrapOrThrow(Utils.data(image: object), StorageError.encodeData)
        })
    }

    func load(forKey key: String) throws -> Image {
        return try commonLoad(forKey: key, fromData: { data in
            return try unwrapOrThrow(Utils.image(data: data), StorageError.decodeData)
        })
    }
}
