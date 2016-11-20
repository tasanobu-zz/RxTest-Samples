//
//  MapTests.swift
//  RxTest-Sample
//
//  Created by Kazunobu Tasaka on 11/14/16.
//  Copyright © 2016 Abema TV. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
import RxCocoa
import RxTest
@testable import RxTest_Sample

class MapTests: XCTestCase {
    
    private var scheduler: TestScheduler!
    private var observer: TestableObserver<Int>!
    private var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        observer = scheduler.createObserver(Int.self)
        disposeBag = DisposeBag()
    }

    func test_map() {
        // 1. 仮想時間 0 を指定しTestSchedulerを生成
        let scheduler = TestScheduler(initialClock: 0)
        
        // 2. TestableObserver<Int> を `仮想時間` `値` を指定して生成
        let xs = scheduler.createHotObservable([
            next(150, 1),  // 第一引数: 仮想時間, 第二引数: 値
            next(210, 0),
            next(240, 4),
            completed(300)
            ])
        
        // 3. TestableObserver<Int> を生成
        let observer = scheduler.createObserver(Int.self)
        
        // 4. 仮想時間 `200` に `observer` を `xs` に subscribe させる
        scheduler.scheduleAt(200) {
            xs.map { $0 * 2 }
                .subscribe(observer)
                .addDisposableTo(self.disposeBag)
        }
        
        // 5. schedulerを開始
        scheduler.start()
        
        
        /// 6. TestableObserver が受信したイベントを検証
        let expectedEvents = [
            next(210, 0 * 2),
            next(240, 4 * 2),
            completed(300)
        ]
        XCTAssertEqual(observer.events, expectedEvents)
        
        
        /// 6. TestableObservable が subscribe/unsubscribe された仮想時間を検証
        let expectedSubscriptions = [
            Subscription(200, 300)
        ]
        XCTAssertEqual(xs.subscriptions, expectedSubscriptions)
    }
}
