//
//  SearchViewModel.swift
//  RxTest-Sample
//
//  Created by Kazunobu Tasaka on 11/14/16.
//  Copyright © 2016 Abema TV. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    let disposeBag = DisposeBag()
    // api call status: .loading, .loaded, .error
    var state: Variable<State>  = Variable(.loaded([]))
    // followers list
    var users: Variable<[User]> = Variable([])
    // Client which has a web API logic
    let client: Client
    
    init(client: Client) {
        self.client = client
    }
    
    // Action method to search followers
    func searchFollowers(ofUser user: String) {
        state.value = .loading
        client.fetchFollowers(ofUser: user)
            .subscribe { event in
                switch event {
                case .next(let users) :
                    self.state.value = .loaded(users)
                    self.users.value = users
                case .error(let e):
                    self.state.value = .error(e as? Client.Error ?? .unknown)
                    self.users.value = []
                default: // ignore `.completed`
                    break
                }
            }
            .addDisposableTo(disposeBag)
    }
}

enum State {
    case loading
    case loaded([User])
    case error(Client.Error)
}

extension State: Equatable {
    static func ==(lhs: State, rhs: State) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):  return true
        case (.loaded, .loaded):    return true
        case (.error(let e1), .error(let e2)) where e1 == e2:   return true
        default:                    return false
        }
    }
}
