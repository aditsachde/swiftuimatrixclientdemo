//
//  KDataSourceDelegate.swift
//  Koven
//
//  Created by Adit Sachde on 1/14/21.
//

import SwiftUI
import MatrixKit

class KDataSourceDelegate: ObservableObject {//NSObject, MXKDataSourceDelegate, ObservableObject {
    @Published var array: [MXKRoomBubbleCellDataStoring] = []
    var data: MXKRoomDataSource
    init(dataSource: MXKRoomDataSource) {
        self.data = dataSource
        data.finalizeInitialization()
        data.paginate(200, direction: __MXTimelineDirection.init(1), onlyFromStore: false) { (UInt) in
            print("omegalul paginate sucess")
        } failure: { _ in
            print("omegalul paginate false")
        }
    }
    func reload() {
        data.paginate(200, direction: __MXTimelineDirectionBackwards, onlyFromStore: false) { (UInt) in
            print("omegalul paginate sucess")
            self.array = self.data.getBubbles()
        } failure: { error in
            print("omegalul paginate \(error.debugDescription)")
        }
    }
}
    /*
    @Published var array: [MXKRoomBubbleCellDataStoring] = []
    var data: KDataSource
    
    init(dataSource: KDataSource) {
        self.data = dataSource
        super.init()
        data.delegate = self
        data.paginate(200, direction: __MXTimelineDirection.init(1), onlyFromStore: false) { (UInt) in
            print("omegalul paginate sucess")
        } failure: { _ in
            print("omegalul paginate false")
        }

    }
    
    deinit {
        data.delegate = nil
    }
    
    func cellViewClass(for cellData: MXKCellData!) -> MXKCellRendering.Type! {
        return nil
    }
    
    func cellReuseIdentifier(for cellData: MXKCellData!) -> String! {
        return nil
    }
    
    func dataSource(_ dataSource: MXKDataSource!, didCellChange changes: Any!) {
        array = data.getBubbles()
    }
    
    func reload() {
        data.paginate(200, direction: __MXTimelineDirectionBackwards, onlyFromStore: false) { (UInt) in
            print("omegalul paginate sucess")
            self.array = self.data.getBubbles()
        } failure: { error in
            print("omegalul paginate \(error.debugDescription)")
        }
    }
}
*/
