//
//  User.swift
//  RxTest-Sample
//
//  Created by Kazunobu Tasaka on 11/14/16.
//  Copyright © 2016 Abema TV. All rights reserved.
//

import Foundation

struct User {
    var id: Int
    var name: String
    
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int,
            let name = dictionary["login"] as? String else {
                return nil
        }
        self.init(id: id, name: name)
    }
    
    init?(json: Any) {
        guard let json = json as? [String: Any] else {
            return nil
        }
        self.init(dictionary: json)
    }
}

extension User: Equatable {
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
