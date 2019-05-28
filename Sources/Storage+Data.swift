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

    func load(forKey key: String) throws -> Data {
        if let object = cache.object(forKey: key as NSString) as? Data {
            return object
        } else {
            let data = try Data(contentsOf: fileUrl(forKey: key))
            cache.setObject(data as AnyObject, forKey: key as NSString)
            return data
        }
    }
}
