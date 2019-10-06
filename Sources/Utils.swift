//
//  Utils.swift
//  EasyStash
//
//  Created by khoa on 27/05/2019.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit
public typealias Image = UIImage
#elseif canImport(AppKit)
import AppKit
public typealias Image = NSImage
#endif

func unwrapOrThrow<T>(_ optional: Optional<T>, _ error: Error) throws -> T {
    if let value = optional {
        return value
    } else {
        throw error
    }
}

extension Bool {
    func trueOrThrow(_ error: Error) throws {
        if !self {
            throw error
        }
    }
}

/// Use to wrap primitive Codable
public struct TypeWrapper<T: Codable>: Codable {
    enum CodingKeys: String, CodingKey {
        case object
    }

    public let object: T

    public init(object: T) {
        self.object = object
    }
}

class Utils {
    static func image(data: Data) -> Image? {
        #if canImport(UIKit)
        return UIImage(data: data)
        #elseif canImport(AppKit)
        return NSImage(data: data)
        #else
        return nil
        #endif
    }

    static func data(image: Image) -> Data? {
        #if canImport(UIKit)
        return image.jpegData(compressionQuality: 0.9)
        #elseif canImport(AppKit)
        return image.tiffRepresentation
        #else
        return nil
        #endif
    }
}

public struct File {
    public let name: String
    public let url: URL
    public let modificationDate: Date?
    public let size: UInt64?
}

