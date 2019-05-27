//
//  Storage.swift
//  EasyStash-iOS
//
//  Created by khoa on 27/05/2019.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

public extension Storage {
    struct Options {

    }
}

public enum StorageError: Error {

}

public class Storage {
    public let cache = NSCache<NSString, AnyObject>()
    public let options: Options

    public init(options: Options) throws {
        self.options = options
    }

    public func save(object: AnyObject, key: String) throws {

    }

    public func load<T>(key: String, as: T.Type) throws -> T {
        fatalError()
    }
}
