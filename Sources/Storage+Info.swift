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
            let filePath = folderUrl.appendingPathComponent(content)
            let attributes = try fileManager.attributesOfItem(atPath: filePath.path)
            if let size = attributes[.size] as? UInt64 {
                totalSize += size
            }
        }

        return totalSize
    }
}
