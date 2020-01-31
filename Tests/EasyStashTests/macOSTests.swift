//
//  macOSTests
//  EasyStash-iOS
//
//  Created by khoa on 27/05/2019.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import XCTest
import EasyStash

#if canImport(AppKit)
import AppKit

class macOSTests: XCTestCase {
    var storage: Storage!

    override func setUp() {
        super.setUp()

        var options = Options()
        options.searchPathDirectory = FileManager.SearchPathDirectory.cachesDirectory
        storage = try! Storage(options: options)
    }

    func testObject() {
        let users = [
            User(city: "Oslo", name: "A"),
            User(city: "Berlin", name: "B"),
            User(city: "New York", name: "C")
        ]

        do {
            try storage.save(object: users, forKey: "users")
            storage.cache.removeAllObjects()
            let loadedUsers = try storage.load(forKey: "users", as: [User].self)
            XCTAssertEqual(users, loadedUsers)

            try storage.remove(forKey: "users")
            XCTAssertFalse(storage.exists(forKey: "users"))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testImage() {
        let image = NSImage(color: NSColor.red, size: CGSize(width: 100, height: 100))

        do {
            try storage.save(object: image, forKey: "image")
            storage.cache.removeAllObjects()
            let loadedImage: Image = try storage.load(forKey: "image")
            XCTAssertEqual(loadedImage.size, CGSize(width: 100, height: 100))

            try storage.remove(forKey: "image")
            XCTAssertFalse(storage.exists(forKey: "image"))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

#endif
