//
//  RoomView.swift
//  Koven
//
//  Created by Adit Sachde on 1/14/21.
//

import SwiftUI
import MatrixSDK
import MatrixKit

struct RoomView: UIViewControllerRepresentable {
    typealias UIViewControllerType = MXKRoomViewController
    
    var controller: MXKRoomViewController
    private var dataSource: MXKRoomDataSource
    
    init(roomId: String, session: MXSession) {
        let dataSource = MXKRoomDataSource(roomId: roomId, andMatrixSession: session)
        dataSource!.finalizeInitialization()
        let viewController = RoomViewController()
        
        
        viewController.finalizeInit()
        //viewController.displayRoom(dataSource)
        self.dataSource = dataSource!
        self.controller = viewController
    }
    
    func makeUIViewController(context: Context) -> MXKRoomViewController {
        return self.controller
    }
    
    func updateUIViewController(_ activityIndicator: MXKRoomViewController, context: Context) {
        controller.displayRoom(dataSource)
        activityIndicator.displayRoom(dataSource)
    }
}
