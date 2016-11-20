//
//  SearchViewModelTests.swift
//  RxTest-Sample
//
//  Created by Kazunobu Tasaka on 11/14/16.
//  Copyright © 2016 Abema TV. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import RxTest_Sample

class SearchViewModelTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()

        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    func test_state_when_searchFollowers_succeeded() {
        let users = [User(id: 12091114, name: "tunepolo")]
        
        // 1. Instantiate TestableObserver
        let observer = scheduler.createObserver(State.self)
        // 2. Instantiate TestableObservable
        let observable = scheduler.createColdObservable([
            next(100, users)
            ])
        
        // 3. Instantiate MockClient with the observable
        let client = MockClient(response: observable)
        // 4. Instantiate SearchViewModel with MockClient
        let viewModel = SearchViewModel(client: client)
        // 5. Make `observer` subscribe `observable` at virtual time 100
        scheduler.scheduleAt(100) {
            viewModel.state.asObservable()
                .subscribe(observer)
                .addDisposableTo(self.disposeBag)
        }
        // 6. Call `viewModel.searchFollowers()` at virtual time 200
        scheduler.scheduleAt(200) {
            viewModel.searchFollowers(ofUser: "tasanobu")
        }
        // 7. Start `scheduler`
        scheduler.start()
        
        // 8. Inspect the events that the observer received
        let expectedEvents = [
            next(100, State.loaded([])),
            next(200, State.loading),
            next(300, State.loaded(users))
        ]
        XCTAssertEqual(observer.events, expectedEvents)
    }
    
    func test_state_when_searchFollowers_failed() {
        let observer = scheduler.createObserver(State.self)
        let xs: TestableObservable<[User]> = scheduler.createColdObservable([
            error(100, Client.Error.unknown)
            ])
        let client = MockClient(response: xs)
        let viewModel = SearchViewModel(client: client)
        
        scheduler.scheduleAt(100) {
            viewModel.state
                .asObservable()
                .subscribe(observer)
                .addDisposableTo(self.disposeBag)
        }
        
        scheduler.scheduleAt(200) {
            viewModel.searchFollowers(ofUser: "tasanobu")
        }
        
        scheduler.start()
        
        let expectedEvents = [
            next(100, State.loaded([])),
            next(200, State.loading),
            next(300, State.error(Client.Error.unknown))
        ]
        XCTAssertEqual(observer.events, expectedEvents)
    }
}
