//
//  UITableView.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 03/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

extension UITableView {

    /// Reactive wrapper for `UITableView.insertRows(at:with:)`
    var insertRowsEvent: ControlEvent<[IndexPath]> {
        let source = rx.methodInvoked(#selector(UITableView.insertRows(at:with:)))
                .map { a in
                    return a[0] as! [IndexPath]
                }
        return ControlEvent(events: source)
    }

    /// Reactive wrapper for `UITableView.endUpdates()`
    var endUpdatesEvent: ControlEvent<Bool> {
        let source = rx.methodInvoked(#selector(UITableView.endUpdates))
                .map { _ in
                    return true
                }
        return ControlEvent(events: source)
    }

    /// Reactive wrapper for when the `UITableView` inserted rows and ended its updates.
    var insertedItems: ControlEvent<[IndexPath]> {
        let insertEnded = Observable.combineLatest(
                insertRowsEvent.asObservable(),
                endUpdatesEvent.asObservable(),
                resultSelector: { (insertedRows: $0, endUpdates: $1) }
        )
        let source = insertEnded.map { $0.insertedRows }
        return ControlEvent(events: source)
    }
}
