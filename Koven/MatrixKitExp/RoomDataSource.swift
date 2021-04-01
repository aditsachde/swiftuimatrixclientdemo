//
//  RoomDataSource.swift
//  Koven
//
//  Created by Adit Sachde on 1/12/21.
//

import SwiftUI
import MatrixSDK

class RoomDataSource: ObservableObject {
    @Published var events: [MXEvent] = []
    var timeline: MXEventTimeline
    var initialized: Bool = false
    
    init(room: MXRoom) {
        self.timeline = MXEventTimeline()
        
        room.liveTimeline { time in
            self.timeline = time!
            _ = self.timeline.listenToEvents { event, direction, state in
                self.events.append(event)
            }
            self.timeline.resetPagination()
            self.timeline.paginate(200, direction: MXTimelineDirection.backwards, onlyFromStore: false) { response in
                print("omegalul \(response)")
                print("omegalul \(self.events)")
                self.initialized = true
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.events.removeAll()
    }
    
    func paginate(count: Int) {
        guard initialized else {
            return
        }
        self.timeline.paginate(200, direction: MXTimelineDirection.backwards, onlyFromStore: false) { response in
            print("omegalul \(response)")
            print("omegalul \(self.events)")
        }
    }
}

