//
//  Storage.swift
//  EasyStash-iOS
//
//  Created by khoa on 27/05/2019.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

public enum StorageError: Error {
    case notFound
    case encodeData
    case decodeData
    case createFile
    case missingFileAttributeKey(key: FileAttributeKey)
    case expired(maxAge: Double)
}

public class Storage {
    public let cache = NSCache<NSString, AnyObject>()
    public let options: Options
    public let folderUrl: URL
    public let fileManager: FileManager = .default

    public init(options: Options) throws {
        self.options = options

        let url = try fileManager.url(
            for: options.searchPathDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )

        self.folderUrl = url
            .appendingPathComponent(options.folder, isDirectory: true)

        try createDirectoryIfNeeded(folderUrl: folderUrl)
        try applyAttributesIfAny(folderUrl: folderUrl)
    }

    public func exists(forKey key: String) -> Bool {
        return fileManager.fileExists(atPath: fileUrl(forKey: key).path)
    }

    public func removeAll() throws {
        cache.removeAllObjects()
        try fileManager.removeItem(at: folderUrl)
        try createDirectoryIfNeeded(folderUrl: folderUrl)
    }

    public func remove(forKey key: String) throws {
        cache.removeObject(forKey: key as NSString)
        try fileManager.removeItem(at: fileUrl(forKey: key))
    }
}

extension Storage {
    func createDirectoryIfNeeded(folderUrl: URL) throws {
        var isDirectory = ObjCBool(true)
        guard !fileManager.fileExists(atPath: folderUrl.path, isDirectory: &isDirectory) else {
            return
        }

        try fileManager.createDirectory(
            atPath: folderUrl.path,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }

    func applyAttributesIfAny(folderUrl: URL) throws {
        #if os(iOS) || os(tvOS)
            let attributes: [FileAttributeKey: Any] = [
                FileAttributeKey.protectionKey: FileProtectionType.complete
            ]

            try fileManager.setAttributes(attributes, ofItemAtPath: folderUrl.path)
        #endif
    }

    func fileUrl(forKey key: String) -> URL {
        return folderUrl.appendingPathComponent(key, isDirectory: false)
    }
    
    func verify(maxAge: TimeInterval,
                forKey key: String,
                fromDate date: @escaping (() -> Date) = { Date() }) throws -> Bool {
        date().timeIntervalSince(try modificationDate(forKey: key)) <= maxAge
    }
}

extension Storage {
    func commonSave(object: AnyObject, forKey key: String, toData: () throws -> Data) throws {
        let data = try toData()
        cache.setObject(object, forKey: key as NSString)
        try fileManager
            .createFile(atPath: fileUrl(forKey: key).path, contents: data, attributes: nil)
            .trueOrThrow(StorageError.createFile)
    }

    func commonLoad<T>(forKey key: String,
                       withExpiry expiry: Expiry,
                       fromDate date: @escaping (() -> Date) = { Date() },
                       fromData: (Data) throws -> T) throws -> T {
        switch expiry {
        case .never:
            break
        case .maxAge(let maxAge):
            guard try verify(maxAge: maxAge, forKey: key, fromDate: date) else {
                throw StorageError.expired(maxAge: maxAge)
            }
        }
        
        if let object = cache.object(forKey: key as NSString) as? T {
            return object
        } else {
            let data = try Data(contentsOf: fileUrl(forKey: key))
            let object = try fromData(data)
            cache.setObject(object as AnyObject, forKey: key as NSString)
            return object
        }
    }
}

extension Storage {
    public enum Expiry {
        case never
        case maxAge(maxAge: TimeInterval)
    }
}
