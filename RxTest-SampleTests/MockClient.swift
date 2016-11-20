//
//  MockClient.swift
//  RxTest-Sample
//
//  Created by Kazunobu Tasaka on 11/15/16.
//  Copyright © 2016 Abema TV. All rights reserved.
//

import Foundation
import RxSwift
import RxTest
@testable import RxTest_Sample

class MockClient: Client {
    
    // Observable used as API response
    let response: TestableObservable<[User]>
    
    init(response: TestableObservable<[User]>) {
        self.response = response
        super.init()
    }
    override func fetchFollowers(ofUser user: String) -> Observable<[User]> {
        return response.asObservable()
    }
}
