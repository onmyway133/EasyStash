//
//  User.swift
//  EasyStash
//
//  Created by khoa on 27/05/2019.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

struct User: Codable, Equatable {
    let city: String
    let name: String
}

class User2: NSObject, Codable {
    let city: String
    let name: String

    required init(city: String, name: String) {
        self.city = city
        self.name = name
        super.init()
    }
}

class User3: NSObject, NSCoding {
    let city: String
    let name: String

    required init(city: String, name: String) {
        self.city = city
        self.name = name
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(city, forKey: "city")
        aCoder.encode(name, forKey: "name")
    }
}
