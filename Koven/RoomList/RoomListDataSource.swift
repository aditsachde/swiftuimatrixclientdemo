//
//  RoomListDataSource.swift
//  Koven
//
//  Created by Adit Sachde on 1/12/21.
//

import SwiftUI
import MatrixKit
import Foundation

class RoomListDataSource: ObservableObject {
    // MARK: Initialize
    var session: MXSession
    @Published var hasUnread: Bool = false
    @Published var roomSummaries: [MXRoomSummary] = []
    var roomCount: Int {
        roomSummaries.count
    }
    
    init(session: MXSession) {
        self.session = session
        loadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        roomSummaries.removeAll()
    }
    
    // MARK: Functions
    func sort() {
        roomSummaries.sort(by: { $0.lastMessageOriginServerTs > $1.lastMessageOriginServerTs })
    }
    
    
    func markAllAsRead() {
        for roomSummary in roomSummaries {
            roomSummary.room.markAllAsRead()
        }
    }
    
    
    func loadData() {
        print("loggerlogging loaded data")
        NotificationCenter.default.removeObserver(self)
        self.roomSummaries.removeAll()
        
        var roomSummaries: [MXRoomSummary] = []
        
        for roomSummary: MXRoomSummary in self.session.roomsSummaries() {
            guard !roomSummary.hiddenFromUser else { continue }
            roomSummaries.append(roomSummary)
        }
        
        self.session.resetRoomsSummariesLastMessage()
        //self.session.fixRoomsSummariesLastMessage()
        sort()
        
        // Listen to MXRoomSummary
        NotificationCenter.default.addObserver(self, selector: #selector(didRoomSummaryChanged(_:)), name: NSNotification.Name.mxRoomSummaryDidChange, object: nil)
        
        // Listen to MXSession room count changes
        NotificationCenter.default.addObserver(self, selector: #selector(didMXSessionHaveNewRoom(_:)), name: NSNotification.Name.mxSessionNewRoom, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didMXSessionDidLeaveRoom(_:)), name: NSNotification.Name.mxSessionDidLeaveRoom, object: nil)
        
        // Listen to the direct rooms list
        NotificationCenter.default.addObserver(self, selector: #selector(didDirectRoomsChange(_:)), name: NSNotification.Name.mxSessionDirectRoomsDidChange, object: nil)
        
        // Listen to MXSession state change
        NotificationCenter.default.addObserver(self, selector: #selector(didMXSessionStateChange(_:)), name: NSNotification.Name.mxSessionStateDidChange, object: nil)
        
        
        self.roomSummaries = roomSummaries
    }
    
    // MARK: Event Processing
    @objc func didDirectRoomsChange(_ notification: Notification) {
        // TODO: Notify when direct rooms changed?
    }
    
    @objc func didMXSessionStateChange(_ notification: Notification) {
        if self.session.state.rawValue >= MXSessionStateStoreDataReady.rawValue {
            if roomSummaries.count == 0 {
                loadData()
            } else {
                sort()
            }
        }
    }
    
    @objc func didRoomSummaryChanged(_ notification: Notification) {
        print("loggerlogging summary did change!")
        let roomSummary: MXRoomSummary = notification.object as! MXRoomSummary
        //print("loggerlogging \(roomSummary.lastMessageString)")
        guard let roomInArrayIndex = self.roomSummaries.firstIndex(where: { $0.roomId == roomSummary.roomId }) else {
            return
        }
        if roomSummary.hiddenFromUser {
            roomSummaries.remove(at: roomInArrayIndex)
        } else {
            roomSummaries[roomInArrayIndex] = roomSummary
        }
        sort()
        //for x in roomSummaries {
        //    print("loggerlogging summary \(x.lastMessageOriginServerTs) \(String(describing: x.roomId))")
        //}
    }
    
    @objc func didMXSessionHaveNewRoom(_ notification: Notification) {
        print("loggerlogging did join new room!")
        guard let roomId = notification.userInfo?[kMXSessionNotificationRoomIdKey] as? String else {
            return
        }
        print("loggerlogging \(roomId)")
        guard roomSummaries.firstIndex(where: { $0.roomId == roomId }) == nil else { return }
        guard let roomSummary = self.session.roomSummary(withRoomId: roomId) else { return }
        guard !roomSummary.hiddenFromUser else { return }
        roomSummaries.append(roomSummary)
        sort()
        for x in roomSummaries {
            print("loggerlogging new room \(x.lastMessageOriginServerTs) \(String(describing: x.roomId))")
        }
    }
    
    @objc func didMXSessionDidLeaveRoom(_ notification: Notification) {
        print("loggerlogging did leave room!")
        guard let roomId = notification.userInfo?[kMXSessionNotificationRoomIdKey] as? String else {
            return
        }
        roomSummaries.removeAll(where: { $0.roomId == roomId })
    }
    
}
