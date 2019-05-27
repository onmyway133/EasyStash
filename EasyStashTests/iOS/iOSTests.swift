//
//  iOSTests
//  EasyStash-iOS
//
//  Created by khoa on 27/05/2019.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import XCTest
import EasyStash

class iOSTests: XCTestCase {

    var storage: Storage!

    override func setUp() {
        super.setUp()

        let options = Storage.Options()
        storage = try! Storage(options: options)
    }

    func testObject() {
        let users = [
            User(city: "Oslo", name: "A"),
            User(city: "Berlin", name: "B"),
            User(city: "New York", name: "C")
        ]

        do {
            try storage.save(object: users, key: "users")
            let loadedUsers = try storage.load(key: "users", as: [User].self)
            XCTAssertEqual(users, loadedUsers)

            try storage.remove(key: "users")
            XCTAssertFalse(storage.exists(key: "users"))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testImage() {

    }
}
