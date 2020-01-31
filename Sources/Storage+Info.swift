//
//  Storage+Info.swift
//  EasyStash
//
//  Created by khoa on 27/05/2019.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

public extension Storage {
    /// Get folder size in byte
    func folderSize() throws -> UInt64 {
        var totalSize: UInt64 = 0
        let contents = try fileManager.contentsOfDirectory(atPath: folderUrl.path)
        try contents.forEach { content in
            let fileUrl = folderUrl.appendingPathComponent(content)
            let attributes = try fileManager.attributesOfItem(atPath: fileUrl.path)
            if let size = attributes[.size] as? UInt64 {
                totalSize += size
            }
        }

        return totalSize
    }

    /// Check if folder has no files
    func isEmpty() throws -> Bool {
        let contents = try fileManager.contentsOfDirectory(atPath: folderUrl.path)
        return contents.isEmpty
    }

    func files() throws -> [File] {
        let contents = try fileManager.contentsOfDirectory(atPath: folderUrl.path)
        let files: [File] = try contents.map { try file(forKey: $0) }
        return files
    }

    /// Remove all files matching predicate
    func removeAll(predicate: (File) -> Bool) throws {
        let files = try self.files().filter(predicate)
        try files.forEach {
            cache.removeObject(forKey: $0.name as NSString)
            try remove(forKey: $0.name)
        }
    }
    
    func file(forKey key: String) throws -> File {
        let fileUrl = self.fileUrl(forKey: key)
        let attributes = try fileManager.attributesOfItem(atPath: fileUrl.path)
        let modificationDate: Date? = attributes[.modificationDate] as? Date
        let size: UInt64? = attributes[.size] as? UInt64

        return File(
            name: key,
            url: fileUrl,
            modificationDate: modificationDate,
            size: size
        )
    }
    
    func modificationDate(forKey key: String) throws -> Date {
        guard let modificationDate = try file(forKey: key).modificationDate else {
            throw StorageError.missingFileAttributeKey(key: .modificationDate)
        }
        return modificationDate
    }
}
