//: Playground - noun: a place where people can play

import UIKit
import RxSwift

let o = Observable.of(1,2,3)
    .map { n -> Int in
        print(n)
        return n
    }
    .publish()
    .connect()


//o.subscribe(onNext: { print("1: \($0)") })
//o.connect()
//o.subscribe(onNext: { print("2: \($0)") })



//let subject = PublishSubject<Int>()
//
//subject
//    .map { print($0) }
//
//subject.onNext(1)
