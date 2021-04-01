//
//  RoomView.swift
//  Koven
//
//  Created by Adit Sachde on 1/12/21.
//

import SwiftUI
import MatrixSDK

struct OldRoomView: View {
    @StateObject var dataSource: RoomDataSource
    
    
    var body: some View {
        List {
            ForEach(dataSource.events, id: \.eventId) { event -> AnyView in
                //return Text(String())
                if case .roomMessage = event.eventType {
                    let content = event.content
                    guard content != nil || content!["body"] != nil else {
                        print("omegalul \(event)")
                        
                        return AnyView(Text("omegalul No Content \(event.debugDescription)"))
                    }
                    //return AnyView(Text("\(content!["type"] as! String)"))
                    //if content!["type"] as! String == "m.room.message" {
                    let body = content!["body"]
                    if let bodyString = body as? String {
                        return AnyView(Text("\(bodyString)").scaleEffect(x: 1, y: -1, anchor: .center))
                    }
                    //}
                }
                return AnyView(EmptyView())
            }
            Text("End of list").onAppear(perform: {
                dataSource.paginate(count: 100)
            })
        }.scaleEffect(x: 1, y: -1, anchor: .center)
    }
}
