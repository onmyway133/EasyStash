//
//  iOSTests
//  EasyStash-iOS
//
//  Created by khoa on 27/05/2019.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import XCTest
import EasyStash

#if canImport(UIKit)
import UIKit

class iOSTests: XCTestCase {

    var storage: Storage!

    override func setUp() {
        super.setUp()

        let options = Options()
        storage = try! Storage(options: options)
    }

    override func tearDown() {
        super.tearDown()

        try? storage.removeAll()
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
        let image = UIColor.red.image(CGSize(width: 100, height: 100))

        do {
            try storage.save(object: image, forKey: "image")
            storage.cache.removeAllObjects()
            let loadedImage: UIImage = try storage.load(forKey: "image")
            XCTAssertEqual(
                loadedImage.size.mutiply(loadedImage.scale),
                image.size.mutiply(image.scale)
            )

            try storage.remove(forKey: "image")
            XCTAssertFalse(storage.exists(forKey: "image"))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testData() {
        let string = "Hello world"
        let data = string.data(using: .utf8)!

        do {
            try storage.save(object: data, forKey: "data")
            let loadedData: Data = try storage.load(forKey: "data")
            let loadedString = String(data: loadedData, encoding: .utf8)
            XCTAssertEqual(string, loadedString)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testPrimitive() {
        do {
            try storage.save(object: 1, forKey: "number")
            try storage.save(object: "Hello", forKey: "string")

            let number = try storage.load(forKey: "number", as: Int.self)
            let string = try storage.load(forKey: "string", as: String.self)

            XCTAssertEqual(number, 1)
            XCTAssertEqual(string, "Hello")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testFolderSize() {
        let image = UIColor.red.image(CGSize(width: 100, height: 100))

        do {
            try storage.save(object: image, forKey: "image")
            XCTAssertTrue(try storage.folderSize() > 2000)
            XCTAssertEqual(try storage.isEmpty(), false)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testFiles() {
        do {
            try storage.save(object: 1, forKey: "one")
            try storage.save(object: 2, forKey: "two")
            try storage.save(object: 3, forKey: "three")

            let files = try storage
                .files()
                .sorted(by: { $0.modificationDate! < $1.modificationDate! })

            XCTAssertEqual(files.count, 3)
            XCTAssertEqual(files[0].name, "one")
            XCTAssertEqual(files[1].name, "two")
            XCTAssertEqual(files[2].name, "three")
            XCTAssertTrue(files[0].size! > 0)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testRemoveAllPredicate() {
        do {
            try storage.save(object: 1, forKey: "one")
            try storage.save(object: 2, forKey: "two")
            try storage.save(object: 3, forKey: "three")

            try storage.removeAll(predicate: { $0.name == "one" })
            let files = try storage.files()
            XCTAssertEqual(files.count, 2)

            do {
                let _ = try storage.load(forKey: "one", as: Int.self)
            } catch {
                XCTAssertNotNil(error)
                let nsError = error as NSError
                XCTAssertEqual(nsError.code, 260)
            }

            let two = try storage.load(forKey: "two", as: Int.self)
            XCTAssertEqual(two, 2)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testRemoveAll() {
        do {
            try storage.save(object: 1, forKey: "one")
            try storage.save(object: 2, forKey: "two")
            try storage.save(object: 3, forKey: "three")

            try storage.removeAll()

            XCTAssertFalse(storage.exists(forKey: "one"))
            XCTAssertFalse(storage.exists(forKey: "two"))
            XCTAssertFalse(storage.exists(forKey: "three"))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testPerformanceUsingEncoder() {
        let users = Array(0..<10_000).map { _ in User2(city: "Oslo", name: "A") }
        measure {
            let encoder = JSONEncoder()
            let _ = try! encoder.encode(users)
        }
    }

    func testPerformanceUsingKeyArchiver() {
        let users = Array(0..<10_000).map { _ in User3(city: "Oslo", name: "A") }
        measure {
            do {
                try NSKeyedArchiver.archivedData(withRootObject: users, requiringSecureCoding: false)
            } catch {
                
            }    
        }
    }
}

extension CGSize {
    func mutiply(_ value: CGFloat) -> CGSize {
        return CGSize(width: width * value, height: height * value)
    }
}

#endif
