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
        public var searchPathDirectory: FileManager.SearchPathDirectory = .cachesDirectory
        public var folder: String = "Default"

        public init() {}
    }
}

public enum StorageError: Error {
    case notFound
}

public class Storage {
    public let cache = NSCache<NSString, AnyObject>()
    public let options: Options
    public let folderUrl: URL
    public let fileManager: FileManager

    public init(options: Options, fileManager: FileManager = .default) throws {
        self.options = options
        self.fileManager = fileManager

        let url = try fileManager.url(
            for: options.searchPathDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )

        self.folderUrl = url.appendingPathComponent(options.folder, isDirectory: true)
        try createDirectoryIfNeeded(folderUrl: folderUrl)
    }

    public func save(object: AnyObject, key: String) throws {
        cache.setObject(object, forKey: key as NSString)
    }

    public func load<T>(key: String, as: T.Type) throws -> T {
        if let object = cache.object(forKey: key as NSString) as? T {
            return object
        } else {
            throw StorageError.notFound
        }
    }

    public func exists(key: String) -> Bool {
        return fileManager.fileExists(atPath: filePath(key: key).absoluteString)
    }

    public func removeAll() throws {
        try fileManager.removeItem(at: folderUrl)
        try createDirectoryIfNeeded(folderUrl: folderUrl)
    }
}

extension Storage {
    func createDirectoryIfNeeded(folderUrl: URL) throws {
        guard !fileManager.fileExists(atPath: folderUrl.absoluteString) else {
            return
        }

        try fileManager.createDirectory(
            atPath: folderUrl.absoluteString,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }

    func filePath(key: String) -> URL {
        return folderUrl.appendingPathComponent(key)
    }
}
