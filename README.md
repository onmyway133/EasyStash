<div align='center'>
    <img src='Screenshots/logo.png'>
</div>

[![CI Status](https://img.shields.io/circleci/project/github/onmyway133/EasyStash.svg)](https://circleci.com/gh/onmyway133/EasyStash)
[![Version](https://img.shields.io/cocoapods/v/EasyStash.svg?style=flat)](http://cocoadocs.org/docsets/EasyStash)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/EasyStash.svg?style=flat)](http://cocoadocs.org/docsets/EasyStash)
[![Platform](https://img.shields.io/cocoapods/p/EasyStash.svg?style=flat)](http://cocoadocs.org/docsets/EasyStash)
![Swift](https://img.shields.io/badge/%20in-swift%205.0-orange.svg)

## Description

EasyStash is an easy and lightweight persistence framework in Swift. With simple abstraction over `NSCache` and `FileManager`, it saves us from tedious work of saving and loading objects. There are no clever async, expiry handling or caching strategy for now, just save and load.

- [x] Swift 5
- [x] Support iOS, macOS, tvOS, watchOS
- [x] Synchronous APIs with explicit try catch
- [x] Persist UIImage/NSImage
- [x] Persist Codable objects, including primitive types

## Usage

The main and only class is `Storage` which encapsulates memory and disk cache.

With `Options`, we can customize `folder` name, `searchPathDirectory`, `encoder` and `decoder` for `Codable`

```swift
let options = Options()
options.folder = "Users"
storage = try! Storage(options: options)
```

## Installation

**EasyStash** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'EasyStash'
```

**EasyStash** is also available through [Carthage](https://github.com/Carthage/Carthage).
To install just write into your Cartfile:

```ruby
github "onmyway133/EasyStash"
```

**EasyStash** can also be installed manually. Just download and drop `Sources` folders in your project.

## Author

Khoa Pham, onmyway133@gmail.com

## Contributing

We would love you to contribute to **EasyStash**, check the [CONTRIBUTING](https://github.com/onmyway133/EasyStash/blob/master/CONTRIBUTING.md) file for more info.

## License

**EasyStash** is available under the MIT license. See the [LICENSE](https://github.com/onmyway133/EasyStash/blob/master/LICENSE.md) file for more info.
