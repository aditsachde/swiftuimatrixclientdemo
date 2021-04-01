//
//  KCellView.swift
//  Koven
//
//  Created by Adit Sachde on 1/14/21.
//

import SwiftUI
import MatrixKit

struct KCellView: View {
    @StateObject var dataSource: KDataSourceDelegate
    @State var updater = false
    
    var body: some View {
        print("omegalul \(dataSource.data.state)")
        print("omegalul \(dataSource.data.roomState.historyVisibility)")
        print("omegalul \(dataSource.data.isLive)")
        print("omegalul \(dataSource.array)")

        return VStack {
            Button(action: {
                self.updater.toggle()
                self.dataSource.reload()
                print("omegalul toggle \(self.updater)")
            }) {
                Text(String(self.updater))
            }
            List {
                ForEach(dataSource.array, id: \.events.first?.eventId) { bubble in
                    Text(bubble.textMessage)
                }
            }
        }
    }
}
