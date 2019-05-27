//
//  Storage.swift
//  EasyStash-iOS
//
//  Created by khoa on 27/05/2019.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation
#if os(iOS) || os(tvOS)
    import UIKit
    public typealias Image = UIImage
#elseif os(OSX)
    import AppKit
    public typealias Image = NSImage
#endif

public extension Storage {
    struct Options {
        public var searchPathDirectory: FileManager.SearchPathDirectory = .cachesDirectory
        public var folder: String = "Default"

        public init() {}
    }
}

public enum StorageError: Error {
    case notFound
    case encodeData
    case decodeData
    case createFile
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
            .appendingPathComponent(Bundle.main.bundleIdentifier ?? "")
            .appendingPathComponent(options.folder, isDirectory: true)

        try createDirectoryIfNeeded(folderUrl: folderUrl)
        try applyAttributesIfAny(folderUrl: folderUrl)
    }

    public func exists(key: String) -> Bool {
        return fileManager.fileExists(atPath: fileUrl(key: key).absoluteString)
    }

    public func removeAll() throws {
        cache.removeAllObjects()
        try fileManager.removeItem(at: folderUrl)
        try createDirectoryIfNeeded(folderUrl: folderUrl)
    }

    public func remove(key: String) throws {
        try fileManager.removeItem(at: fileUrl(key: key))
    }
}

public extension Storage {
    func save<T: Codable>(object: T, key: String) throws {
        cache.setObject(object as AnyObject, forKey: key as NSString)
        let encoder = JSONEncoder()
        let data = try encoder.encode(object)
        try fileManager
            .createFile(atPath: fileUrl(key: key).absoluteString, contents: data, attributes: nil)
            .trueOrThrow(StorageError.createFile)
    }

    func load<T: Codable>(key: String, as: T.Type) throws -> T {
        if let object = cache.object(forKey: key as NSString) as? T {
            return object
        } else {
            let data = try Data(contentsOf: fileUrl(key: key))
            let decoder = JSONDecoder()
            let object = try decoder.decode(T.self, from: data)
            cache.setObject(object as AnyObject, forKey: key as NSString)
            return object
        }
    }
}

public extension Storage {
    func save(object: Image, key: String) throws {
        cache.setObject(object as AnyObject, forKey: key as NSString)
        let data = try unwrapOrThrow(self.data(image: object), StorageError.encodeData)
        try fileManager
            .createFile(atPath: fileUrl(key: key).absoluteString, contents: data, attributes: nil)
            .trueOrThrow(StorageError.createFile)
    }

    func load(key: String) throws -> Image {
        if let object = cache.object(forKey: key as NSString) as? Image {
            return object
        } else {
            let data = try Data(contentsOf: fileUrl(key: key))
            let object = try unwrapOrThrow(self.image(data: data), StorageError.decodeData)
            cache.setObject(object as AnyObject, forKey: key as NSString)
            return object
        }
    }

    private func image(data: Data) -> Image? {
        #if os(iOS) || os(tvOS)
            return UIImage(data: data)
        #elseif os(OSX)
            return NSImage(data: data)
        #endif
    }

    private func data(image: Image) -> Data? {
        #if os(iOS) || os(tvOS)
            return image.jpegData(compressionQuality: 0.9)
        #elseif os(OSX)
            return image.tiffRepresentation
        #endif
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

    func applyAttributesIfAny(folderUrl: URL) throws {
        #if os(iOS) || os(tvOS)
            let attributes: [FileAttributeKey: Any] = [
                FileAttributeKey.protectionKey: FileProtectionType.complete
            ]

            try fileManager.setAttributes(attributes, ofItemAtPath: folderUrl.absoluteString)
        #endif
    }

    func fileUrl(key: String) -> URL {
        return folderUrl.appendingPathComponent(key)
    }
}

private func unwrapOrThrow<T>(_ optional: Optional<T>, _ error: Error) throws -> T {
    if let value = optional {
        return value
    } else {
        throw error
    }
}

private extension Bool {
    func trueOrThrow(_ error: Error) throws {
        if !self {
            throw error
        }
    }
}
