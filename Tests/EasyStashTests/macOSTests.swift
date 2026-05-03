import Testing
import EasyStash

#if canImport(AppKit)
import AppKit

@Suite
@MainActor
struct macOSTests {
    let storage: Storage

    init() throws {
        var options = Options()
        options.searchPathDirectory = .cachesDirectory
        storage = try Storage(options: options)
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
        let image = NSImage(color: NSColor.red, size: CGSize(width: 100, height: 100))

        try storage.save(object: image, forKey: "image")
        storage.cache.removeAllObjects()
        let loadedImage: Image = try storage.load(forKey: "image")
        #expect(loadedImage.size == CGSize(width: 100, height: 100))

        try storage.remove(forKey: "image")
        #expect(!storage.exists(forKey: "image"))
    }
}

#endif
