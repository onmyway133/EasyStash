//
//  Options.swift
//  EasyStash
//
//  Created by khoa on 27/05/2019.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

public struct Options {
    /// By default, files are saved into searchPathDirectory/folder
    public var searchPathDirectory: FileManager.SearchPathDirectory
    public var folder: String = (Bundle.main.bundleIdentifier ?? "").appending("/Default")

    /// Optionally, you can set predefined directory for where to save files
    public var directoryUrl: URL? = nil

    public var encoder: JSONEncoder = JSONEncoder()
    public var decoder: JSONDecoder = JSONDecoder()

    public init() {
        #if os(tvOS)
            searchPathDirectory = .cachesDirectory
        #else
            searchPathDirectory = .applicationSupportDirectory
        #endif
    }
}
