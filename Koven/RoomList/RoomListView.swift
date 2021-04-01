//
//  RoomListView.swift
//  Koven
//
//  Created by Adit Sachde on 1/12/21.
//

import SwiftUI
import MatrixSDK

struct RoomListView: View {
    @EnvironmentObject var matrixState: MatrixState
    @StateObject var roomList: RoomListDataSource
    
    var body: some View {
        let rooms = roomList.roomSummaries
        return NavigationView {
            List {
                ForEach(rooms.indices) { i in
                    //NavigationLink(destination: KCellView(dataSource: KDataSourceDelegate(dataSource: MXKRoomDataSource(roomId: room.roomId, andMatrixSession: session)))) {//RoomView(dataSource: RoomDataSource(room: room.room))) {
                    NavigationLink(
                        destination: RoomView(roomId: rooms[i].roomId, session: matrixState.session).navigationBarTitle(rooms[i].displayname, displayMode: .inline)) {
                        RoomItemView(roomSummary: self.$roomList.roomSummaries[i])
                    }//.background(Color.black.opacity(0.75))
                }
            }
            //.navigationTitle("Rooms")
            .navigationBarTitle("Rooms", displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink(
                destination: GlobalSettingsView(),
                label: {
                    Image(systemName: "person.crop.circle")
                }
            ))
            //.navigationSubtitle("Test")
            //.background(Color.black.opacity(0.75))
        }.navigationViewStyle(StackNavigationViewStyle())
        //.background(Color.black.opacity(0.75))
        
    }
}
