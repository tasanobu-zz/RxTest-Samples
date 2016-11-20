//
//  Client.swift
//  RxTest-Sample
//
//  Created by Kazunobu Tasaka on 11/14/16.
//  Copyright © 2016 Abema TV. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class Client {
    enum Error: Swift.Error {
        case unknown, timeout
    }
    
    // https://api.github.com/users/:user/followers
    func fetchFollowers(ofUser user: String) -> Observable<[User]> {
        let url = URL(string: "https://api.github.com/users/\(user)/followers")!
        let request = URLRequest(url: url)
        return URLSession.shared
            .rx
            .json(request: request)
            .map { response in
                guard let json = response as? [[String: Any]] else {
                    return []
                }
                return json.flatMap { User(json: $0) }
        }
    }
}
