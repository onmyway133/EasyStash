//
//  Options.swift
//  EasyStash
//
//  Created by khoa on 27/05/2019.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

public struct Options {
    public var searchPathDirectory: FileManager.SearchPathDirectory = .applicationSupportDirectory
    public var folder: String = (Bundle.main.bundleIdentifier ?? "").appending("/Default")
    public var encoder: JSONEncoder = JSONEncoder()
    public var decoder: JSONDecoder = JSONDecoder()

    public init() {}
}
