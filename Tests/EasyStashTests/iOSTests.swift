import Testing
import EasyStash

#if canImport(UIKit)
import UIKit

@Suite
@MainActor
struct iOSTests {
    let storage: Storage

    init() throws {
        storage = try Storage(options: Options())
        try storage.removeAll()
    }

    @Test func object() throws {
        let users = [
            User(city: "Oslo", name: "A"),
            User(city: "Berlin", name: "B"),
            User(city: "New York", name: "C")
        ]

        try storage.save(object: users, forKey: "users")
        storage.cache.removeAllObjects()
        let loadedUsers = try storage.load(forKey: "users", as: [User].self)
        #expect(users == loadedUsers)

        try storage.remove(forKey: "users")
        #expect(!storage.exists(forKey: "users"))
    }

    @Test func image() throws {
        let image = UIColor.red.image(CGSize(width: 100, height: 100))

        try storage.save(object: image, forKey: "image")
        storage.cache.removeAllObjects()
        let loadedImage: UIImage = try storage.load(forKey: "image")
        #expect(
            loadedImage.size.multiply(loadedImage.scale) == image.size.multiply(image.scale)
        )

        try storage.remove(forKey: "image")
        #expect(!storage.exists(forKey: "image"))
    }

    @Test func data() throws {
        let string = "Hello world"
        let data = string.data(using: .utf8)!

        try storage.save(object: data, forKey: "data")
        let loadedData: Data = try storage.load(forKey: "data")
        let loadedString = String(data: loadedData, encoding: .utf8)
        #expect(string == loadedString)
    }

    @Test func primitive() throws {
        try storage.save(object: 1, forKey: "number")
        try storage.save(object: "Hello", forKey: "string")

        let number = try storage.load(forKey: "number", as: Int.self)
        let string = try storage.load(forKey: "string", as: String.self)

        #expect(number == 1)
        #expect(string == "Hello")
    }

    @Test func folderSize() throws {
        let image = UIColor.red.image(CGSize(width: 100, height: 100))

        try storage.save(object: image, forKey: "image")
        #expect(try storage.folderSize() > 2000)
        #expect(try !storage.isEmpty())
    }

    @Test func files() throws {
        try storage.save(object: 1, forKey: "one")
        try storage.save(object: 2, forKey: "two")
        try storage.save(object: 3, forKey: "three")

        let files = try storage
            .files()
            .sorted { $0.modificationDate! < $1.modificationDate! }

        #expect(files.count == 3)
        #expect(files[0].name == "one")
        #expect(files[1].name == "two")
        #expect(files[2].name == "three")
        #expect(files[0].size! > 0)
    }

    @Test func removeAllPredicate() throws {
        try storage.save(object: 1, forKey: "one")
        try storage.save(object: 2, forKey: "two")
        try storage.save(object: 3, forKey: "three")

        try storage.removeAll(predicate: { $0.name == "one" })
        let files = try storage.files()
        #expect(files.count == 2)

        #expect(throws: (any Error).self) {
            _ = try storage.load(forKey: "one", as: Int.self)
        }

        let two = try storage.load(forKey: "two", as: Int.self)
        #expect(two == 2)
    }

    @Test func removeAll() throws {
        try storage.save(object: 1, forKey: "one")
        try storage.save(object: 2, forKey: "two")
        try storage.save(object: 3, forKey: "three")

        try storage.removeAll()

        #expect(!storage.exists(forKey: "one"))
        #expect(!storage.exists(forKey: "two"))
        #expect(!storage.exists(forKey: "three"))
    }
}

extension CGSize {
    func multiply(_ value: CGFloat) -> CGSize {
        CGSize(width: width * value, height: height * value)
    }
}

#endif
