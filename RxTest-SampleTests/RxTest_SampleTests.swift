//
//  RxTest_SampleTests.swift
//  RxTest-SampleTests
//
//  Created by Kazunobu Tasaka on 11/9/16.
//  Copyright © 2016 Abema TV. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
import RxCocoa
import RxTest
@testable import RxTest_Sample

class RxTest_SampleTests: XCTestCase {
    
    private var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }
    
    func test_map() {
        // 1. Instantiate TestScheduler by designating virtual time 0
        let scheduler = TestScheduler(initialClock: 0)
        
        // 2. Instantiate TestableObservable<Int>
        // by designating value together with virtual time.
        let observable = scheduler.createHotObservable([
            next(150, 1),  // (virtual time, value)
            next(210, 0),
            next(240, 4),
            completed(300)
            ])
        
        // 3. Instantiate TestableObserver<Int>
        let observer = scheduler.createObserver(Int.self)
        
        // 4. Make `observer` subscribe `observable` at virtual time 200
        scheduler.scheduleAt(200) {
            observable.map { $0 * 2 }
                .subscribe(observer)
                .addDisposableTo(self.disposeBag)
        }
        
        // 5. Start `scheduler`
        scheduler.start()
        
        let expectedEvents = [
            next(210, 0 * 2),
            next(240, 4 * 2),
            completed(300)
        ]
        // 6-1. Compare the events which `observer` received
        XCTAssertEqual(observer.events, expectedEvents)
        
        let expectedSubscriptions = [
            Subscription(200, 300)
        ]
        // 6-2. Compare the virtual times when `observable` was subscribed/unsubscribed
        XCTAssertEqual(observable.subscriptions, expectedSubscriptions)
    }
}



